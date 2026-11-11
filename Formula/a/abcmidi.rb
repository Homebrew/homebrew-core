class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.11.11.zip"
  sha256 "83b04edaf3c6cdf51873346739a30de9700af16dfb3a029c07a65a1191ce824b"
  license "GPL-2.0-or-later"
  head "https://github.com/sshlien/abcmidi.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f75ffa5980d4d7d1ff420718da152b0905da69abd54bc23acfbaf0d80492e4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a95540316b9b28df68cd92831303aa45b2506d90b5d732493e641e498fe4cb17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3420c46bb603cd58ca7458708edf6cd162832ed8ca3ab974f42841d4adbdde05"
    sha256 cellar: :any,                 arm64_linux:       "9a88d323f668edae57ec5e6d1c10810aebced31638f4cf47212d19a63356ce59"
    sha256 cellar: :any,                 x86_64_linux:      "fabdb45f4eaf39d67a2edb7e699247e7bd8736bb31f8ea35ab0d169a8f454b0d"
  end

  deny_network_access!

  def install
    chmod "+x", "configure"
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
