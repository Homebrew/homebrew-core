class Libxshmfence < Formula
  desc "X.Org: Shared memory 'SyncFence' synchronization primitive"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxshmfence-1.3.2.tar.xz"
  sha256 "870df257bc40b126d91b5a8f1da6ca8a524555268c50b59c0acd1a27f361606f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0b26a0dbdeb9038ecd113fd855346b2a3a466562838c829c4fcb05880a2fefe6"
    sha256 cellar: :any,                 arm64_sonoma:   "7ba2bacada910453a50e48e0513ba4ed0eb8ab1390f6d456a50c19d15c9b6e82"
    sha256 cellar: :any,                 arm64_ventura:  "9965e61e94b01b1b56db8f6c0d908e226133e0818fa06c45ea0089f499c746f6"
    sha256 cellar: :any,                 arm64_monterey: "7b78f18eb800573284bf21013d554a84a89059de1dff8d2433debedcf8f07afc"
    sha256 cellar: :any,                 arm64_big_sur:  "ae4ff0449a655fb0232a0e4050ebd219876e2e1e18d8e3af1bfe0a09bf7d3862"
    sha256 cellar: :any,                 sonoma:         "f73e7e5a5a8a7ae2f2f4c390b4ab736ec501c860a8ba3b1d185ca05374ba98be"
    sha256 cellar: :any,                 ventura:        "14444b0b9ca86f0e7e268ba20cd2f835ad988d0b4c1dd045e41ad7e847d0866a"
    sha256 cellar: :any,                 monterey:       "e42af7c5bdd609cf576b788467eac1accfdbb229049005f0213216a408888b2f"
    sha256 cellar: :any,                 big_sur:        "f115cf1d363821613850b45647ffe514d9682ff5cd853ad1cf9ce44f0c74933c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531196f68924b7a5f887156766dbc04ae745e8315f6e41adbe812e1119bc6d20"
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
