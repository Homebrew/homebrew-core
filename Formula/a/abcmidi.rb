class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.11.16.zip"
  sha256 "e2d7086b79c4d79b39c0aa96e9dd4674db2e5d40c6566e4d2138f55836fc61ec"
  license "GPL-2.0-or-later"
  head "https://github.com/sshlien/abcmidi.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "832efa07f19dd78dad45c0aa53365fa89acaef7a94d28fc76335f030f8e0532f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d5c60225a934a0d10268806671e1201416a0933589590cf58e553a4a8c1828c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c5ffe72ccbb2a2c2e79ef743069325c796ecc6903cb1489d86761f7c70f62be"
    sha256 cellar: :any,                 arm64_linux:       "407e707a11b7c48b221770643e56553d8fc9198a8f00aa693604f54a372516e5"
    sha256 cellar: :any,                 x86_64_linux:      "7cc42e70beeb46126672280dc7ce995aedff856b6d644f0c68f8e05be292a7bf"
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
