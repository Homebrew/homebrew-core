class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.34.2/mk-configure-0.34.2.tar.gz"
  sha256 "7ca9b577e2521ea79cf0a7c95e4339e5b49e9fe852777220687995529ace7cbf"

  bottle do
    cellar :any_skip_relocation
    sha256 "6953adbce89d8a07e95d89431881dbc3bf100e5de24ade46c409740db728fe8b" => :catalina
    sha256 "59821ba5bb3b8801fe52e309813b4edec6615a9698de164364ca8e723fa2ecb9" => :mojave
    sha256 "762f92188096b5c68bf6696a86310e6893829a67ca1bc3bf404fa931c6a7f48b" => :high_sierra
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
