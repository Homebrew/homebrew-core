class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.02.21.zip"
  sha256 "138eddaa54668cd6308536c41e22c4d91c137913dc826ed288cb203a951475d5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1709463f22df8c7feb82f4cad785a59634d85775acb406b88cda02b2b9164154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63fff62b134b7bd301a5a98eac9cdd08d66296db8cbe937371053a2fca4e3e68"
    sha256 cellar: :any_skip_relocation, monterey:       "0f78a51d03ed61206ec606d39610faac5a64501e291a9f2ddcd2c3ca46598913"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4e1810328c8deda7d45ca4a6f5fb9ca56302bd34f3aad668cf894fd5200f347"
    sha256 cellar: :any_skip_relocation, catalina:       "2ad2910eb0d453091f100485e6048cba1914c931f778b2ea2c7a94b659489c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84bccf39c1ab337f7fea78b15cb6a1ddfa197bac5e23ab505c287f9dcf054602"
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
