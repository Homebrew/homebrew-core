class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.01.21.zip"
  sha256 "d7ca26cbf5fd1401cb41b69b5eae79aaad6046f779fe8081a9bd900d257cbc8c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd255ccb471d2b61f24ff70efa7ff0ceb9efefe974b23f6e1c3780d614012e78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ade743aab81e8c544db2a493cbf82987b83d57572e495075ef0b92ae20d60317"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6b130a10233cecdb6cebf097464784585dd8d97d1df7d549d70eef4edfc7ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "0e920db99a13fa5bea25320cd06977af60d5bda6bc5f7c4a8e9b0cd33a9136f7"
    sha256 cellar: :any_skip_relocation, monterey:       "bb4586d7cf1eb2ac64efc462a3f1ec5c2df2dd9eb9d6ddea09b8563355c34ce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "050ec73ec6f05641f68a58aec222e8d3a57c0d89e7495c2579d3f3de9478eed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a07ab56abf711ef98e7fc68d01d05879c0d61a98ef1898d6be01214a5afb827"
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
