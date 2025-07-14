class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.06.27.zip"
  sha256 "617b4e8b2cb4608677627e2b04998d0ff252e95d63d8694b1b763376c9b6c8cd"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bacbedeb4f65551a9c7008d5cc482e8ec645c4fff54fa8785c71cebf510abeb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12183fd273d8cea05c6e7e683bbf060bf8751f3e0a6f74453167afdfe1a82333"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e18860b3130c1fd2c13187fcece0e17e05c700e01096a1c190c6bd6f225401cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77a8696a94d1d5eda7f0132e51c6abd411d95927f34e3a24d27ae964a84cb2b"
    sha256 cellar: :any_skip_relocation, ventura:       "67a6fe2788a02a49e045c6574d545c05fc09ff68be4fb48034694c600029896f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d085029a820b547f1fee7b9729c2ebd1a42b643731e361ea49588dc86d1e4112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1383c9dd85d4e213bf849e1808789f036d89b80524f6be7e22187ed0aeb73aed"
  end

  def install
    system "./configure", *std_configure_args
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
      %%MIDI program 23 % 23 Tango Accordion
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system bin/"abc2midi", testpath/"balk.abc"
  end
end
