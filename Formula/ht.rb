class Ht < Formula
  desc "Viewer/editor/analyzer for executables"
  homepage "https://hte.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2"
  sha256 "31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70"
  license "GPL-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_big_sur: "67aa1b783d01e759a908a568cfc1715e614bff7b77171fc82af00e2af682b464"
    sha256 cellar: :any,                 monterey:      "cf85f1fc8724c40f8f03a109f8a39b35e84358796b8fe17de1e907f49dcad53f"
    sha256 cellar: :any,                 big_sur:       "68a9ebfab03bd7d4f5e61d26075d07ee692002a07b8e5f201ae84ebbac45e5dd"
    sha256 cellar: :any,                 catalina:      "75ab4e842bc671346e7e75ef512f5f2b3d55008a07d91437a9ba46e9c9dcb1b4"
    sha256 cellar: :any,                 mojave:        "9ba777d460dbc11e7c119d6924c765c0d3fb9c50953ed833a07de5e7eb9f6807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74b56b840ef0c1ccbba640ef5625dc0b4f24c6b89220eed18769084064ca590"
  end

  depends_on "lzo"

  uses_from_macos "ncurses"

  def install
    # Fix compilation with Xcode 9
    # https://github.com/sebastianbiallas/ht/pull/18
    inreplace "htapp.cc", "(abs(a - b) > 1)", "(abs((int)a - (int)b))"

    chmod 0755, "./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make", "install"
  end

  test do
    assert_match "ht #{version}", shell_output("#{bin}/ht -v")
  end
end
