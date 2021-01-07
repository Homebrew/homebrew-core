class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.36.0/mk-configure-0.36.0.tar.gz"
  sha256 "a7becc4411dc2b137110b1543c6067b3db11db6baa4a6b303916605f0f2d55ea"

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5bc4a9bc45792bed751f3dc08ec1c0e73885c15f3e33c66c80bccfff913120e1" => :big_sur
    sha256 "bab03e2a9f0585c8225bde715df65bab1561472332aec46df45a03d63eed6003" => :arm64_big_sur
    sha256 "46eeafa552c407c5e43ef5ff9fe17331e047063e96c7e4c422ca81e60e448477" => :catalina
    sha256 "d79a5855774a12a0729cd3f18c4fa623a6b0263e89dc83a7b97a31843bc1980f" => :mojave
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
