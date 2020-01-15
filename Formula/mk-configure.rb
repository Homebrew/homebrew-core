class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.32.1/mk-configure-0.32.1.tar.gz"
  sha256 "0b9d9b409e6eb7d3820c64a972078f4380697c68abafee7ec16a7eb74cf2eb9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "23d95312221d156245f2812acbd886642e403af8b7f754d3230583d6dd1d3ee2" => :catalina
    sha256 "23d95312221d156245f2812acbd886642e403af8b7f754d3230583d6dd1d3ee2" => :mojave
    sha256 "23d95312221d156245f2812acbd886642e403af8b7f754d3230583d6dd1d3ee2" => :high_sierra
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
