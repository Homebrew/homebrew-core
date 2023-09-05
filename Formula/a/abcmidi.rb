class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.08.31.zip"
  sha256 "1ee16e0c2f3c53a5776c842481b187b624660de0e65875a817cb36c1a87a9184"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acf2becd57447e486b764378fd34eae0b627bdc3575c290686e89e422e0f88d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3189b254de7b9da5bae1aff24f578d8916a93091b0c9ce1a89d80a2fac1a5606"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf06dce9d798afd437a0b151c8f77c10ce3ac4c5278ae0ff410a6fb34eab092d"
    sha256 cellar: :any_skip_relocation, ventura:        "43e4a27b8f492814497d05d9fffd88b19e426328bbf5583ac1c1a5c70860e360"
    sha256 cellar: :any_skip_relocation, monterey:       "311edd8fe4b042d954bec1064a17922254d3f8f35062c1eff15d556a26d495ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b097eb4580dce2b889e395794496d48bc58746afe2806a85ba15a62dae37dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b76cf9ab4de2788125cd77674714c2d77e4d099b7260b9e436779f68da2c3b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
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

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
