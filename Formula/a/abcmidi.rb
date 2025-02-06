class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.02.02.zip"
  sha256 "7630225501410b95d30be0ec7c968f8a3d65f0d32cd68a90875a1a55a99d2140"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39ad1d54305eba8f93118ad10ca6b2882acc76e540bc5fbdb236fcf2962e1e96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5987053af41fa2a2e93030b259179df2c9dc12e242070e2ff57bca86448c31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69daaf7603ef4ec76ea4a1e662feb7190a43610d6e79522d12d4c62945e3a9c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "81b1611cc2d7e58dff64b5e272fb13cb8ee713d3724a180be06789f7ad7ff9bb"
    sha256 cellar: :any_skip_relocation, ventura:       "e8be8254f8d91941532d631b3c5aae324f71843bb9c7c6390d9117cfd441f401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334346b7fba0ecc65999982f5fd42ae64009aefcb172a7f5a7dc9f5c7678d278"
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
