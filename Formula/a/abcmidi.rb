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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65b2f0d1dbd3ebecd4d6eda3c87cfe2a3b792ee59981f293674f44310a48060d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c31ba861d4213fbf7adf4f0a5f92c81915cdfdd5183aa968593ca3c61019d401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb8523260e76a7cfcbe6cc0a9111179db4d15519336de55ccf8c5a28a7b398ea"
    sha256 cellar: :any,                 arm64_linux:       "c36ff933fb866159d4d1d18ae8e827498ba5b30f8764232f2f766d72bddacd52"
    sha256 cellar: :any,                 x86_64_linux:      "e0f54246e9d142792b04197e348dd00abeadea45c82c5f6ba373a61ece53c069"
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
