class Libxshmfence < Formula
  desc "X.Org: Shared memory 'SyncFence' synchronization primitive"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxshmfence-1.3.1.tar.xz"
  sha256 "1129f95147f7bfe6052988a087f1b7cb7122283d2c47a7dbf7135ce0df69b4f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a28329811422f189228b3fb3edddc4db7fdb54265d933da3c2379b90f0ba7e88"
    sha256 cellar: :any,                 arm64_monterey: "d54d02c984d1c3004dc80c6293a11a334074ef3ce84d5a411f3250bc9a8b22d2"
    sha256 cellar: :any,                 arm64_big_sur:  "a20786f8e3b41c75c7a8f6ec72e135d6e8a4bedfa9a052174f80467fc4e18b77"
    sha256 cellar: :any,                 ventura:        "daf1efe95074195c6d97cc4f4229d08e931391b201a7188caf18d48a9c57ec62"
    sha256 cellar: :any,                 monterey:       "fb31054f7e6e05c95d9e06ce328471128fa536b8f154a6dd33aaa9eb804f1980"
    sha256 cellar: :any,                 big_sur:        "2a0ad3f3f628be1aae3ba5b3fc9f467fd5d855c5e6187c21e315875ff65dc8d9"
    sha256 cellar: :any,                 catalina:       "db84e2577b6d8ee05c841d8a779873a303da9e836be8afe0e1a8e3e18e777323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4a8107cc0119312c78821e27241616dca90e38c9ff26801b88e5b99d985bc7"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => [:build, :test]

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/xshmfence.h"

      int main(int argc, char* argv[]) {
        struct xshmfence *fence;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
