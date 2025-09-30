class Libxau < Formula
  desc "X.Org: A Sample Authorization Protocol for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXau-1.0.12.tar.xz"
  sha256 "74d0e4dfa3d39ad8939e99bda37f5967aba528211076828464d2777d477fc0fb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "503040606c5d29dd415f2c8dcba7e181d259e4cdff02d1d8bde4e9ea5244765a"
    sha256 cellar: :any,                 arm64_sequoia: "e8a5fedbd9e5c49f10006171decc5b1e56c48fbd4267e7668f813e47c0da984f"
    sha256 cellar: :any,                 arm64_sonoma:  "418c0c03e6422ba74ca2d59b38b6cd01103587ad859932b0bc3519a3f9e26e23"
    sha256 cellar: :any,                 arm64_ventura: "7c0325743bb51f272a93e9fc1edd32f86d89f4f179ba474880b524834d305c2d"
    sha256 cellar: :any,                 sonoma:        "46c7dff8ac6917ffc355a1ac7242fb37f53cb4e7276a9c297b31cd0d35b36b6f"
    sha256 cellar: :any,                 ventura:       "9979936a79a670d37c775a0163b3f24544a264343242b1820332d86e7e5200c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec2a9c4d8d2311c730503f3b7976086612efce6a9a03193508f61f47d8ef5c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaab2aad3bf7abb8cf6f1b164cd6648731814a71b1b3cb1141055d48fa07914d"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xauth.h"

      int main(int argc, char* argv[]) {
        Xauth auth;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
