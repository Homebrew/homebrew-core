class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.01.20.zip"
  sha256 "a34d8d55be6f80f84c689c095132fc4de22c3bb91220855a4658513e7f210738"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13a3e8622617de4849b52e8e2937053b5d6e80d45b599b4ac6b8512a90c14236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566f794794d3d5a7436bac70b124f0d1ebdc0eb81a99f1248b23debb56ac302b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ff50dece4c14b73f2aaafbd68da58772c6db9c1f0b878dc9f076214f6ad5cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e1cde1b57a6da6088560b80d68365c6355b92be72cad8c7f46dfeaa2a8cbd97"
    sha256 cellar: :any_skip_relocation, ventura:       "936f150a5b34a618c8bed1ba31fc2dae4484b31bbf314c3cdf2d8c20c23c6c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e675bc87e80c64bdb7ef86c38b5962fa51d1953328bf16e4de9d26bbd214932"
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
