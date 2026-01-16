class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.11.26.zip"
  sha256 "f89b91aee73746c3e8ec487258fbf82f1e1845741adfcaf49514898f938dc695"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fc8a202702c78a650923395b0528d2f7961f5cfe9e53e8a82d4a82a2aa8a4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da50a68a89be2605c527cd5c0f9025d4d8d4dfea9326a7c8470dbec9f15fb45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0a56b9761d078fd11331f4202f8da22c9fa11d7eb5f20569422bbf7a9a2e52e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e809c05a61d154e84a182adb4bbca4c7f966831c1c73f9779239931f9513f47c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7219d7d7024749f3d90344f2c774fd26de914e8e38e132ac95805658459beb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ed39bc81146127d10214cb28859fdfe98ca4fe2ea49b3b24a19382d14738059"
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
