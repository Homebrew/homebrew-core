class Chordii < Formula
  desc "Text file to music sheet converter"
  homepage "https://www.vromans.org/johan/projects/Chordii/"
  url "https://downloads.sourceforge.net/project/chordii/chordii/4.5/chordii-4.5.3.tar.gz"
  sha256 "140d24a8bc8c298e8db1b9ca04cf02890951aa048a656adb7ee7212c42ce8d06"

  bottle do
    cellar :any_skip_relocation
    sha256 "1611b19a86188ebf0adb51613db08e33decc24a0d80616cef4475c28c0dba03e" => :catalina
    sha256 "d43e4f2dacabc0c4caeeaeff753d68616a4e5113def336afc9a4d599f3a9f87f" => :mojave
    sha256 "92b70657704a64aa528b4d0171f2e67e57046969b61aeee6c70b174e6d7cc89b" => :high_sierra
    sha256 "5eed38c2781095a1ea852e8407d791ee09c87f06e8d596e49e3abb685f8234ad" => :sierra
    sha256 "99c022cf0741bca48fd78d1bc5b5f0488e720321133a1357412d2342527a1dd8" => :el_capitan
    sha256 "02cca7ec07939f7b29f1f2c844d250caaa9b7ba7d19e51f9e3eeb636d51b72d4" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.cho").write <<~EOS
      {title:Homebrew}
      {subtitle:I can't write lyrics. Send help}

      [C]Thank [G]You [F]Everyone,
      [C]We couldn't maintain [F]Homebrew without you,
      [G]Here's an appreciative song from us to [C]you.
    EOS

    system bin/"chordii", "--output=#{testpath}/homebrew.ps", "homebrew.cho"
    assert_predicate testpath/"homebrew.ps", :exist?
  end
end
