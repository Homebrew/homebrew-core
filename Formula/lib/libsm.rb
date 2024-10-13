class Libsm < Formula
  desc "X.Org: X Session Management Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libSM-1.2.4.tar.xz"
  sha256 "fdcbe51e4d1276b1183da77a8a4e74a137ca203e0bcfb20972dd5f3347e97b84"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8facc39e8b9c43bab30da7ec4c65f3db7d99f1db5f5c15a81361e9792f9e283d"
    sha256 cellar: :any,                 arm64_sonoma:   "5fe130e27fc7e0c59704c3ea1c2a817de72d69c2bed4174b92e0013567cec0da"
    sha256 cellar: :any,                 arm64_ventura:  "52aaa6c85c70e69100cfa6cb441148339eb5bdb8463c78bb38b59398944426cd"
    sha256 cellar: :any,                 arm64_monterey: "4b10e64bf30541fa93acc224b112edeeb7522296befcb9f1f1c1e485c7fc669b"
    sha256 cellar: :any,                 arm64_big_sur:  "61a50b4361c3d1b3cf69c60d643f0504228038bed2388539495e30dba84b963c"
    sha256 cellar: :any,                 sonoma:         "1140850e0ad7885824e5501e8708f78ae962b88fce0732cb2f56c439af32cd1c"
    sha256 cellar: :any,                 ventura:        "6ad56cbb3883de27c90d4fd7e0151e23dcf7ca02ea1078e4073c6981b6d3341e"
    sha256 cellar: :any,                 monterey:       "0d7ce1d660e8ef4ed982a4f4d7a364d142b9c8601a703ffcaa0ff8ff1193161d"
    sha256 cellar: :any,                 big_sur:        "06a6fe35a153ee5a8411850a719d89f9e7f36c77506f5b6a585bdd5fcca6535a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ccc4a8f2a6436753a14697a081ba4f42d8e2a405b93d1f00265c0067372750"
  end

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
  depends_on "libice"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/SM/SMlib.h"

      int main(int argc, char* argv[]) {
        SmProp prop;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
