class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.11.20.zip"
  sha256 "24c10331dbb1681f10a121b95d3a676c45f0478f91760fa2c74290e8985b556f"
  license "GPL-2.0-or-later"
  head "https://github.com/sshlien/abcmidi.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    manifest_sha256 "346851b5482b542c21bf98a5d9c8d867488a69837f6c2167eb60647d23a1e8c4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1e1cdc4d8ca3ac9e40b42debf021837a993eba184132777e7e5212a4f1236e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64dc1bc87163c6a37b37efc8ec766262546cd21f01c18f9cf689b05db05359d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45bee19f75d2636e4977c3802e68e64f8d07250ea6af1dae12624373b8d49834"
    sha256 cellar: :any,                 arm64_linux:       "5ce03a501d068918495af3f037ca679bc8d2b23143a2271d1e4cf7a815e8454e"
    sha256 cellar: :any,                 x86_64_linux:      "ad598a1f47eba41e36e602f0e3976757460a92aa1f28ce211305afb3cd2e6dc7"
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
