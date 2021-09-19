class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.09.15.zip"
  sha256 "4515032d866146752bb328b23bedcf1c818ce0646aaa33eb3c12c67b8950d590"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00b16479b44b4c6fa1bf11aded56121e3ccfb108c05b13d5e4cdfe0e8afc97df"
    sha256 cellar: :any_skip_relocation, big_sur:       "802b6b4fcb5d064d80b630fb9b1e9b70924e91662efba6394692ee73d39b8a7b"
    sha256 cellar: :any_skip_relocation, catalina:      "ffc7dbb93fc11c9ff2ce9572b75cd592fe93cb61f6de81c72b715e86683c46be"
    sha256 cellar: :any_skip_relocation, mojave:        "a6e1d523da97128e46695caa93c84bc6c5add3a71a889fbc55db6b4a52bea075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1650a67b2fdd3bd362041797cc0251677ebb3280ea4c23c0a64efc370271bc"
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
