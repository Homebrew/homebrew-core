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
    sha256 "7d9ceb180bbc7fa3d57f51c537f1c0e2de03b21386222293bf8352ab7bf7bf6a" => :big_sur
    sha256 "8c03a1f64dbd6b63382f83c4f881a419c4347fd5d817862918974a293ac0be16" => :arm64_big_sur
    sha256 "129f2ade79cb9123a937d7161edb971f8939df544c4a559b319a17dce8428ddd" => :catalina
    sha256 "edf53a9eff012505917554bc4fc313981285fecafdb89b787dcff990f0439a02" => :mojave
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
