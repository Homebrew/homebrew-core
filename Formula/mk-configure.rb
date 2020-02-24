class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.34.0/mk-configure-0.34.0.tar.gz"
  sha256 "32b21dfa16fb315caff9b983373f22b3347d5f1a431ada960ae6a97afcfb6f2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c357fa068eb6cdfde64567dc89dd644fb764febc203bdf0c43b804a039d3c86a" => :catalina
    sha256 "c357fa068eb6cdfde64567dc89dd644fb764febc203bdf0c43b804a039d3c86a" => :mojave
    sha256 "c357fa068eb6cdfde64567dc89dd644fb764febc203bdf0c43b804a039d3c86a" => :high_sierra
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
