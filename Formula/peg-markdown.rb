class PegMarkdown < Formula
  desc "Markdown implementation based on a PEG grammar"
  homepage "https://github.com/jgm/peg-markdown"
  url "https://github.com/jgm/peg-markdown/archive/0.4.14.tar.gz"
  sha256 "111bc56058cfed11890af11bec7419e2f7ccec6b399bf05f8c55dae0a1712980"
  revision 1
  head "https://github.com/jgm/peg-markdown.git"

  bottle do
    cellar :any
    sha256 "08910e3fdd97183865c2839a4e14839826101e6dfa48120aebc60fbe838f0689" => :catalina
    sha256 "a60087175a8f3c5242e9183eeddb433e6bdbe68409cae0a7c61d66da4622b150" => :mojave
    sha256 "207764b26b253904cf61e9e13eb32e81a51d61d548b7dafd366da5a5394a5f08" => :high_sierra
    sha256 "2d75448f008aa176b624ecb02bc6e3f7492ea8953a99f84fcdacc6b301b39412" => :sierra
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
