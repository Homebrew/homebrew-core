class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.11.13.zip"
  sha256 "80d4e8ea2e3474672c18a682331d81e863dbcb935a8c695ae441b96bd53ac319"
  license "GPL-2.0-or-later"
  head "https://github.com/sshlien/abcmidi.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea73dcd4210e106eae5cd5063bf764b2801a5ec809b8db5a21b7c8ff59a8d54e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed08319127f1dc7fc89ce0e62077edd864817dc1a0d53b267213f09fa809dd43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "462a05154809b5b3d1cbf78dfbeec2fd1704ddb3628c2f104f8635daacedd060"
    sha256 cellar: :any,                 arm64_linux:       "bee3155c6e52a2d7c62f5c6d93c2aebddfad4be3db4b095f1935d3b99f69deca"
    sha256 cellar: :any,                 x86_64_linux:      "be542ebe45247ccb791282a46a0eb46f825318c86adaaf60eea7b9d6c586452c"
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
