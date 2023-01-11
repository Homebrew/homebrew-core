class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.01.10.zip"
  sha256 "29095eb7a5f47eebce2980bc7cbdd3b9e60e1c4cbad7441e664dcf151a94ec63"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89d8fc57a0a5cc99c4fb524e3458e198775fc07e7d661d1d8b21292ed9fdbb3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "295be94659d89038908d596a751f862e63df1b008ce79cbc3560cb00e8d4002a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0806d6383fd8da0604647b5d0b67f88ac14a0732e1fa8000a100a311c4808854"
    sha256 cellar: :any_skip_relocation, ventura:        "0750173847f9660de2007b6ae69bb0cf3830342d165021bfb778d4fc66d1ff43"
    sha256 cellar: :any_skip_relocation, monterey:       "512143a82b73280a96e7c06522efa6f296e6daf3f1b6bb9ec65230c2f6d4098e"
    sha256 cellar: :any_skip_relocation, big_sur:        "67dff311fe1bd557c965a95118c8b1770f860d9f3e4840fe6a980d98975c8405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5521193c0e0661f060552a28e39d6e7e6469faefaac29ae7815400d6a8b6b1c"
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
      %%MIDI program 23 % 23 Tango Accordian
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
