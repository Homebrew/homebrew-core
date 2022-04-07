class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.04.06.zip"
  sha256 "53a589b1fadff8ce81b839e4a5f481b6a959f7c7d813f142e33224a7477fbc01"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2784feb0c531557bbb8611a70d27b3c309d9154ea219186aa9ca27b9a3f0f8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bc28859c5ead76cd0ee2a0e202157acfb44ce20e7c8109a614847494786e1b6"
    sha256 cellar: :any_skip_relocation, monterey:       "099f16bc95b46baac1f06d2b06641f27b20e07f37c15fbc51ed6c56f94718d96"
    sha256 cellar: :any_skip_relocation, big_sur:        "c48e4bd4b2fefc92dad32cb29468da0673e84a2a6219f8b9d2c60ce4beeaea8c"
    sha256 cellar: :any_skip_relocation, catalina:       "cccd7ff45a818db542b3abfe97e731d81ffc9307f19490eb2796e15928cb8eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3c6ec8d30aae0fb532f439fcae14e3b53131e5ec98106ac27b132ded7c5c28"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
