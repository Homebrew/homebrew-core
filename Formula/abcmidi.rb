class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.06.14.zip"
  sha256 "844e6d64956c15297115b95b90d2a3588f7272ce7a333ad28a164eb5561478ba"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51212712afe576fabc8a73030b3cd44c0b4600726416ef4bd6a7f82abcbdd467"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4aa1b1b394297f5e302d4c6920cbd28bdfffe4449517ac348d5d505b25984961"
    sha256 cellar: :any_skip_relocation, monterey:       "916c20d77d2426b1d7e596b2f63e8ac07ec00ec5c18539ce8a22d6f260599f6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bb4bd08715090183d80acff85831333bf8a44ec42dfe7ca233468ec59bb0f16"
    sha256 cellar: :any_skip_relocation, catalina:       "55d5bbf9d9764f2a6741b8be69baa6d6f50c58f2726ddb5a9d3fedcc6f0620d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56da92aebeda24d056a5311b4e2b40c4f3873bb59666cb9399e643da811ac83e"
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
