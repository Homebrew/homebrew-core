class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.4.12.tar.gz"
  sha256 "7a28987114cd5e4717b31a96840c0be505d58a07e20dcf26b25add7dbdf2668b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85df1cbad4d3966ee1b85af44f19693aa446136d3e5ca89890e62fa85c6e3e41"
    sha256 cellar: :any,                 arm64_monterey: "d68e99dba29518ea3a0434185366a4b25f2d62e0f4afb228b3a827212bf1f29a"
    sha256 cellar: :any,                 arm64_big_sur:  "888cee4889bc81fe08ed0a44b122844d1b044b63bd7b12511173dd479a551f7e"
    sha256 cellar: :any,                 ventura:        "63ca6d7ad99a9798b135626b4c01f240575517fea9850795e43f667ea64680db"
    sha256 cellar: :any,                 monterey:       "a232778b9bed6b7bc90207373ee899e58368e28cdcbf20857322f70ce20ab5e3"
    sha256 cellar: :any,                 big_sur:        "adb28f352b07a0aa39fc74baf471fa08bce7d0eed6a89ded10c3b6684486f009"
    sha256 cellar: :any,                 catalina:       "069b2a24d4301ddcc5ee1a6de0fd30b6566741c6d10f57e721f38a26c17717fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea7b8c6d48a44940aa63228e787fd40691400f1bb1cb9c6191a6bcd5af4038cb"
  end

  depends_on "luajit"

  # Fix build on Apple Silicon by removing -pagezero_size/-image_base flags.
  # TODO: Remove if upstream PR is merged and included in release.
  # PR ref: https://github.com/nifty-site-manager/nsm/pull/33
  patch do
    url "https://github.com/nifty-site-manager/nsm/commit/00b3ef1ea5ffe2dedc501f0603d16a9a4d57d395.patch?full_index=1"
    sha256 "c05f0381feef577c493d3b160fc964cee6aeb3a444bc6bde70fda4abc96be8bf"
  end

  def install
    inreplace "Lua.h", "/usr/local/include", Formula["luajit"].opt_include
    system "make", "BUNDLED=0", "LUAJIT_VERSION=2.1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
