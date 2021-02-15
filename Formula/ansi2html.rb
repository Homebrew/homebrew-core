class Ansi2html < Formula
  desc "Convert ANSI (terminal) colours and attributes to HTML"
  homepage "https://github.com/pixelb/scripts/blob/master/scripts/ansi2html.sh"
  url "https://raw.githubusercontent.com/pixelb/scripts/944012cdcb995dbab1cc673e8b89d86fbbbefebc/scripts/ansi2html.sh"
  version "0.26"
  sha256 "395be13d03adfccf30b8288555b91af0b2345925ed70b7a1eecca0fa72a9f538"
  license "LGPL-2.0-only"

  bottle :unneeded

  depends_on "gawk"

  def install
    bin.install "ansi2html.sh"
    bin.install_symlink "ansi2html.sh" => "ansi2html"
  end

  test do
    assert_match <<~HTML, pipe_output("#{bin}/ansi2html", "\033[01;34m test")
      <pre>
      <span class="bold"><span class="f4"> test</span></span>
      </pre>
    HTML
  end
end
