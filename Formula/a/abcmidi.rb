class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.10.10.zip"
  sha256 "23335a04071d03ce908da4d6fd8a60ffd8cfb30437165e0107c2d810799cc70b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "480ec32329fcc96c8546f87ecf55c416757c3b08807d2e57f46b7d2356535744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e0ff3ef8f2ac32ce4e6dc88b340ba9c8cd3cb820417ddbe23523a303e50178"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb5f81436e025607b4798c1fd881a420fb3b1bab327a2150216ba1984aa69ae4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6bb7bfe11c2e61d3aff011f449424d9784c96a60c6019c29e6623bea730e911"
    sha256 cellar: :any_skip_relocation, ventura:       "626bba57526d0887aba39c773e6f3f17867b583cc3a32d46829e103a61a303ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c5e49a9c81ce155960e7fded67664adf769f2434e3fa4ffd459b065943ac308"
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
