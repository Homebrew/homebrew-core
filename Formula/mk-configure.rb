class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.38.2/mk-configure-0.38.2.tar.gz"
  sha256 "1e705e11047515aea67327ba67010affcbb77f2f0736eb84a5080249f4ab483e"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f51796e938283023d062a2c9af68dce1d7e5a2a01c91a6c5f057e732a035e11d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f51796e938283023d062a2c9af68dce1d7e5a2a01c91a6c5f057e732a035e11d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24a24408c0e83f9b58dda7659ff788114271c82df8971e17e427d2546b4d5190"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6ea28f0883c69b5315d0f8ab1f362cf871002c06ef1c432cf4fcca7323e361"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6ea28f0883c69b5315d0f8ab1f362cf871002c06ef1c432cf4fcca7323e361"
    sha256 cellar: :any_skip_relocation, big_sur:        "c744781436f5d6b38bfadac871ad6b96f0063e77795fe618338d62a8f664b3de"
    sha256 cellar: :any_skip_relocation, catalina:       "0bb8077da5c7e87944b15a4594ae20b0a714c58dcc3d6ffb90b55f565c19fae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "448c286f524632863c1c8d019b37a10bfb5d97b7039e9a5b5f1398c3f178346c"
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
