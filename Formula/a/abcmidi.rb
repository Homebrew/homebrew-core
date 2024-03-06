class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.03.05.zip"
  sha256 "26647fdee28fc5e8c8bd65e2126cb7d114c4d2fee3f1ba4cc2284e98fc14c829"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b042d2857b4ed1b6a4988dfdebe2bef2c88d7b53b45ca3240f3476dfcebe125"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99737348d0e12faae3aebcc44e3a9dd7b63f12fb7bc8ac96d4780e496dbcd7d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820dee11c885dce6b24c471c2640994d3ad016a5064f94147b3079b4bbe5361f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cd795c0293c71858ae7b3d6b27d07341d053ccc4eb831be06d4d8e888501248"
    sha256 cellar: :any_skip_relocation, ventura:        "eb95b5df6bb1a5a5befb58d7c87f21b6806bd5b52062b6cf86e100b0b4c12612"
    sha256 cellar: :any_skip_relocation, monterey:       "13aa1665026d6d18c85d123276bf06f0db325e1f7bf863aca53319fac31f23c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440edb88c70c79f32c20f4ef95e96ed4ae35356884d902956809ae1cfd5e491f"
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
