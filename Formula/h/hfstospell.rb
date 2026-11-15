class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.4/hfst-ospell-0.5.4.tar.bz2"
  sha256 "ab644c802f813a06a406656c3a873d31f6a999e13cafc9df68b03e76714eae0e"
  license "Apache-2.0"
  revision 5
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6f37dc919e6b410812d812e9572f59e75152367de402c65022b84fa21e800e68"
    sha256 cellar: :any, arm64_tahoe:       "6acf41656584d5141ae13139ceed08bf56e057e2de4cef793b3267a5a2d0a772"
    sha256 cellar: :any, arm64_sequoia:     "f2987bd478497991ef7b8cb85e63a54b0c771deae132a90c790bf5590279e089"
    sha256 cellar: :any, arm64_linux:       "a9fcdd6331abec1f58754e6942bba07f20556cea45a86fcad45218de17b79b2c"
    sha256 cellar: :any, x86_64_linux:      "ca706cd78e71a507c9fee26db0a6dc6d65d0a89ef18e0e83beb7aaf7e637d1e6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"
  depends_on "libarchive"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--without-libxmlpp", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"hfst-ospell", "--version"
  end
end
