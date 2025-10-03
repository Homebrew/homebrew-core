class Libxdmcp < Formula
  desc "X.Org: X Display Manager Control Protocol library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdmcp-1.1.5.tar.xz"
  sha256 "d8a5222828c3adab70adf69a5583f1d32eb5ece04304f7f8392b6a353aa2228c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "34ca0da1c319eeea93ce31badfb5c29c8876cea644754279e93f6cf032ab5cb1"
    sha256 cellar: :any,                 arm64_sequoia:  "b09a915dae5b45371a86f20a4ccce13c16c7a8eadc843b665e91bc5b2d2143ce"
    sha256 cellar: :any,                 arm64_sonoma:   "789326aa88d1b6dbe5dd565e9e70e5031bf63fac39d22cd30d11c1dfc49ffbfb"
    sha256 cellar: :any,                 arm64_ventura:  "5c459f7ceb9793912b76f6a34019aa429a6963e938e685fc2e0cf2e75a88daf4"
    sha256 cellar: :any,                 arm64_monterey: "5aca31f04706d27335ba40875a3653336f470baa1cdacbad1dbea896ab7a4ace"
    sha256 cellar: :any,                 sonoma:         "b43d28c50f25ee0775a1bd4269e236d00e352ac060522bfc9186b35165095c56"
    sha256 cellar: :any,                 ventura:        "f553988c10f628a28ef1f4d8d3ace5d5ffcc147a3ef6958acd679943a2300668"
    sha256 cellar: :any,                 monterey:       "3d062d168fde07ebb9b7e7100ca830bdf2ea498fbb1c572f8584e314bb96054b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a19ed1302e0632f8f6e8276824bb189a4384d007707bfa891d64925af4e6d4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8b9dc2969e85e26c6d426d8865244e1416d73f7f408c9f5404a2a614a62e7d4"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xdmcp.h"

      int main(int argc, char* argv[]) {
        xdmOpCode code;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
