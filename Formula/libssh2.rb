class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://www.libssh2.org/"
  url "https://www.libssh2.org/download/libssh2-1.11.0.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.0/libssh2-1.11.0.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.0.tar.gz"
  sha256 "3736161e41e2693324deb38c26cfdc3efe6209d634ba4258db1cecff6a5ad461"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf0e735085285723dc4a43160c97e73c65c2758127ad18cb1c6f57689a3f567f"
    sha256 cellar: :any,                 arm64_monterey: "86675a61931e93ee3b0451ec80d61b0675981cefa6a25c74485cb0e193a08b6e"
    sha256 cellar: :any,                 arm64_big_sur:  "1e846fb3154b08e1796258e1ef63c861a6fa054f6d93b1fdceb775588dc7c7c6"
    sha256 cellar: :any,                 ventura:        "037e14a2a1c76d5019ab96264574e72e652864da0e01f373e4183c893108f064"
    sha256 cellar: :any,                 monterey:       "9cc91506152ea4a400ff971923e7fab6ad3149c1162cf3baf721d059188fb040"
    sha256 cellar: :any,                 big_sur:        "7ea74deaf8385acc677419003a9a19342b41b278cd44be65a6dc1ae0c81458e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95cbc23269e7b6d5ceb5663731d1f5b09a3fdea56464e6941c3fee6e6fc63e86"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./buildconf" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
