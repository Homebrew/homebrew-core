class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.03.20.zip"
  sha256 "e164f3345104b74da693567b8f8703487d1abf7dab539de286007f8efa28cd05"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02eeac58cdf14ae5fca2cd3a611f465b91e4c84f054c90cc62cfeda8b2cd1e6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aafba32e968bf59ee3464713d8da651e54743c8c6e1616fc11557281bba097d"
    sha256 cellar: :any_skip_relocation, monterey:       "e466151c916010df74433b7825edd047d43e03dc317ff196f8bd0a0c8d7aa8db"
    sha256 cellar: :any_skip_relocation, big_sur:        "b632458cf406ed32ce5018e969498e4388b951892a641dcc44a64d072f90a339"
    sha256 cellar: :any_skip_relocation, catalina:       "ef788fe5ece542a33942ed96154851d15c37fb1f3a9cf58e64bb2e1a912bbb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a490a93c2f542c53fa899281163877c97a4182c3913e555769dba09c7d24b0b"
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
