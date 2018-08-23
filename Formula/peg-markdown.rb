class PegMarkdown < Formula
  desc "Markdown implementation based on a PEG grammar"
  homepage "https://github.com/jgm/peg-markdown"
  url "https://github.com/jgm/peg-markdown/archive/0.4.14.tar.gz"
  sha256 "111bc56058cfed11890af11bec7419e2f7ccec6b399bf05f8c55dae0a1712980"
  head "https://github.com/jgm/peg-markdown.git"

  bottle do
    cellar :any
    sha256 "724cf50020cb91154d7e8dec5a612427cd66469d9469c5141622dafc9c6bba2b" => :mojave
    sha256 "de2ac88d9fbcb0ffc76c35be5e1f6ffbcf359f823a64d497992d6fe54fb68120" => :high_sierra
    sha256 "fe01189854debd593f6106fea4c79cb1f524d377f20d0e23f526e598461fc276" => :sierra
    sha256 "75fc993aa8e861092785f6e235adf55eaf49af419f721ed983e633b9afb96bba" => :el_capitan
    sha256 "8b73ccf611b6639935b1fe7b42d5bab2518703f81b182769c537f7224ac1e803" => :yosemite
    sha256 "67d5b05f4cb166d398f352cfa2a1d9ce97ae6ed1a7da5f8012c1d3544ec496d6" => :mavericks
    sha256 "81b615979242abe96da6a8657c9357ad6f59d585a2533db1469b2e9ead567d9b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "make"
    bin.install "markdown" => "peg-markdown"
  end

  test do
    assert_equal "<p><strong>Homebrew</strong></p>",
      pipe_output("#{bin}/peg-markdown", "**Homebrew**", 0).chomp
  end
end
