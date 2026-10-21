class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/"
  url "https://ifdo.ca/~seymour/runabc/abcMidi-2026.10.16.zip"
  sha256 "f865e7a0107f30b0b6fa005c063c14e7c830f81cd626d872ec9788a912488048"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f3015993eccb6047f2d2224627ab0e1e21cd4905066381fbd093a440f714cf5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf76ba43875c84c447e628bfa2a1752aded13e309e308edb8af230f44a343783"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1dbe97b2daa6d45e7d2402b6bc180254aa36bafb353d703d1ba2c155ed96ea45"
    sha256 cellar: :any,                 arm64_linux:       "a518ccbb355d4edb7eb30391df4bd3a02f21cbbfc361480215eb7830d054405c"
    sha256 cellar: :any,                 x86_64_linux:      "95a08f0a947024cfb69e3a637cf6999c9d0e9d6caf656f0c89651423bacc6a1f"
  end

  deny_network_access!

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
