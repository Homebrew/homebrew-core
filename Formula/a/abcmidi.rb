class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.09.13.zip"
  sha256 "a0cb92907da7d0bc02858cffedc42a2c00bf4b35a1607b18f67010b7f43948b1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eea0123c4aa869bcdabbb420ba7ff7f33dd0229cabf863e0514517b788c0551"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50413bca1c634afc990cf093a17bc149ba0cd9e395f27893be7ca5d4f781b30f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f34c244a50c510b91a2a261828ddf11341d5f2395a7f1c7713c6a457b38e8d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3cffde7071e4396c64a6caa1401b399a246d4a9b296a786e7380e246cc14c60"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0586359b620b71e1a7dcdb21ba110c29782e48993ae922e6045c629fc56774a"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb3386a70c425ef3b0e43fbf2f527707623f0c69c253ae3594914c100505666"
    sha256 cellar: :any_skip_relocation, monterey:       "c1961068773f0da28b00c190133b1e00c37ce2b7b3bdb674eb4f897b96ffd16f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8d89e452406c6462e1b53c5571b29ecf47e55bfa6d5ff5959914d5f0c4e01e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222650ef75dd5743b7ef77f73e39a187823370bb494a91958e8215ea6d8c0d68"
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
