class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.34.0/mk-configure-0.34.0.tar.gz"
  sha256 "32b21dfa16fb315caff9b983373f22b3347d5f1a431ada960ae6a97afcfb6f2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "59cb3bc8e8c34490e50d3d8ffee35db5c6f5ec3b2d452d773fdd3a35ad2f864e" => :catalina
    sha256 "59cb3bc8e8c34490e50d3d8ffee35db5c6f5ec3b2d452d773fdd3a35ad2f864e" => :mojave
    sha256 "9dfe100ba1a66a267d791a986831ce2856db6e074394c3e65fb80c679c19c584" => :high_sierra
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
