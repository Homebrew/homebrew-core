class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.12.05.zip"
  sha256 "bc67e955e2f058ed24b7e1f28ff527b3021bdac994bc7a8eeaa6c2048f123e15"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e49332b0b9bbf0877d1aba08a3b810f915b2379f7b559c06df66485669088da0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee5c3fb2fd141db606367d7c5bd8f88c140e8ca7c440a36c6b007ed0cb252167"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec91e196c4fed3ce13c87b513dc7b8dfdecf8ef3c47289b5142df0476cafea3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cafd3c1826d3b5700cee55e7bcf76dae87017217977a0d46ffe797ff3358c05"
    sha256 cellar: :any_skip_relocation, catalina:       "1c9bfe040998aee3d153c3cb8e54dac1272b4e3eeeea47685c6c831cb4357f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c423b2ae5e98e6cf551dfb9c62865cec252dee737d8e7c25cf7e620b20bdf0aa"
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
