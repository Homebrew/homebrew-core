class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXi-1.8.2.tar.xz"
  sha256 "d0e0555e53d6e2114eabfa44226ba162d2708501a25e18d99cfb35c094c6c104"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "02cb7bb24d30cd4ec0c6a4911e5a01d0c7d174753752671a31669048585f0c69"
    sha256 cellar: :any,                 arm64_sequoia:  "57806e4096680d7fdbfeceea4e2aa04c3d179846b0ba00c9db8daf0319e6f40d"
    sha256 cellar: :any,                 arm64_sonoma:   "474b22f2f4b4bf6945a3ce00400213838ba390542393cdba26c807f39694401b"
    sha256 cellar: :any,                 arm64_ventura:  "e21e8ceae47d1b3ebabdcc9be472620b3f6f1c07aa320c3b9eb42d71d6c0d0fc"
    sha256 cellar: :any,                 arm64_monterey: "72f13ecbdacac0c3c7479459e7f89d339c43d3f26d04cd8ff7fab7ab75938376"
    sha256 cellar: :any,                 sonoma:         "912b8268b30dae048b52740eefbacda1b9767dc2db9469a2d34c395e0752c2b0"
    sha256 cellar: :any,                 ventura:        "7a214e9759c6d33f6554c7941f9fb5a08c2805e514a93053f087899df79a0eae"
    sha256 cellar: :any,                 monterey:       "e1621d00c64c524f3e511f93197e6323ae6c8f63d370730b8cc204ff1cd6c5e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b2b86357aea40aebb92de04c90134a812a6f0f4ead1b0188f4f60b1d1d3846b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6839d93e4dc8d53688515849ec4ec2d830946d6d26f6cfcca6402390bc0f1867"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "xorgproto"

  conflicts_with "libslax", because: "both install `libxi.a`"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/XInput.h"

      int main(int argc, char* argv[]) {
        XDeviceButtonEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
