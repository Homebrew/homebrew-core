class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.30.0/mk-configure-0.30.0.tar.gz"
  sha256 "5c8f953d82a2d36f9492cafcad61d34e81b892d1d91b401af406b086046ef227"

  bottle do
    cellar :any_skip_relocation
    sha256 "5da2a7b494096eedfe770fede39f69845f32890d419a89944ae8ed9352bd8551" => :mojave
    sha256 "1fbce32c61d2840795d80acbb69dba077a17190307e001e7297f34ba279bf2b4" => :high_sierra
    sha256 "1fbce32c61d2840795d80acbb69dba077a17190307e001e7297f34ba279bf2b4" => :sierra
    sha256 "1fbce32c61d2840795d80acbb69dba077a17190307e001e7297f34ba279bf2b4" => :el_capitan
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
