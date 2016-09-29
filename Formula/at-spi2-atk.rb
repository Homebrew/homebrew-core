class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.22/at-spi2-atk-2.22.0.tar.xz"
  sha256 "e8bdedbeb873eb229eb08c88e11d07713ec25ae175251648ad1a9da6c21113c1"

  bottle do
    cellar :any
    sha256 "d011be23d3fd7b8283c6d8272215f46bc96cdccf104393feaba4534cd7d0c4f2" => :sierra
    sha256 "b4882d54f60b72e358085993472ec1ddd7a970a85cb7bf7eea28614eb1a6f4a7" => :el_capitan
    sha256 "ff9994b927e7b0cd7dc4ea4cffec772770f5b67422ce37ce9264d726af72c75c" => :yosemite
    sha256 "c775a1002d8adfaec9ca439b910243702bd50b519e8fec648a776472179dd28e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
