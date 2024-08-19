class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.08.13.zip"
  sha256 "27f87ae51bceb75d6788c7460e4c6de9f793b12bda773811817d55f4619ddacf"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a364f520818ed121e9615048304a696fb9e8ee3077662eb6237e66c391029188"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a5e9642f734cf116f73ffa3f6d7adf596507be4610f00a01cfcd92db9978976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a44cf479da89f735e2f6f43d551fd3e0cbfe1dda7a6d27710e9a9fa928b830"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2a24ad5a9fb10fa4f57545e9e97d3f3a488e4b8e575cf20c3e88f1ac3da2005"
    sha256 cellar: :any_skip_relocation, ventura:        "160f608b74d50891f7be717de97ff4b1d42430686dccf4062eaf8e1af4e63823"
    sha256 cellar: :any_skip_relocation, monterey:       "d467a3bc336f10419aa8ac2fd38c5d46a1954ce29cbb123acdea190366961d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86938753d35ed2ac093da8e3df2e6b8bf497a09f55cbac1dae5ae8fb14cdd4f2"
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
