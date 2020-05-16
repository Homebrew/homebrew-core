class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.34.2/mk-configure-0.34.2.tar.gz"
  sha256 "7ca9b577e2521ea79cf0a7c95e4339e5b49e9fe852777220687995529ace7cbf"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2f0d61a8aa1efb2beee1e0ddab87a6cb4ab3e2ec7e1e68b46e8b9ff7ce26f4c" => :catalina
    sha256 "53a6bd198f8a76c596758418a5b7ada78a31948a8aa003c17456fb766fe1cf40" => :mojave
    sha256 "c2c91a7ac4338aca22b8f310385920f7327179d252b534fbd47471e404dab2b6" => :high_sierra
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
