class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.06.07.zip"
  sha256 "2e42c21452532d1a0cdbe5f53caad2ae4ca6bcb324aeec106f69c58f8fb2d60d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48b815ac71955d5b4008c70c9c5058ced27f1e22d6c97c0b4906f9a8f9d3fee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0f4aa15efde79035cfe61d29e27fcdb8e84856e2b80120eb9e199681a533b3"
    sha256 cellar: :any_skip_relocation, monterey:       "3647112ede5de9b2c9cc955a81681e1c69878ca8482e1f6ed4486fdd19c070e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce001940f06473f5d7ab6cc980c544cd0b0be62f26e9a8c75e0dd1a1b5e3fcc8"
    sha256 cellar: :any_skip_relocation, catalina:       "3a17bd5da6e1da232175cba8987c949934d49fce1c7dceb6b2bee235bed6ec77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc4086b3a744ee4b9f92dbd3ba82c71440f8b8a4832ba64b6576da14860ff4f5"
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
