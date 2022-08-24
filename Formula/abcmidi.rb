class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.08.23.zip"
  sha256 "38d397b8277b5ba3ebd7bf01395c603df7849cf8383975be24b3e7fbde35eebc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5ed9b3d036303eb036253a55d155aab6a1ff6179fadd11a184ea734e9a2fd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b76feb04380e4536fae53f35989a633d42e11beeee6ab0ec86d92b5298163d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "b3887eadfbf8811d6cf294c614eab57af2d96ca5c9e83f79813df6df8f555863"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e27f2b0770a284db9e1dd22217de2af0d08a9cc6bb0da5ef5bb7d20d5a0c485"
    sha256 cellar: :any_skip_relocation, catalina:       "dfa3b5aab89baf0f40e2a5c46164553a07ae6f1be07c352a248685d3308cdbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aebca23a9a04d998096599cc1a4ab072ffd91908720a68659d7f1311e87c067e"
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
