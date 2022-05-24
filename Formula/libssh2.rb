class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://www.libssh2.org/"
  url "https://www.libssh2.org/download/libssh2-1.10.0.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.10.0/libssh2-1.10.0.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.10.0.tar.gz"
  sha256 "2d64e90f3ded394b91d3a2e774ca203a4179f69aebee03003e5a6fa621e41d51"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f9dab718cfa591fa90dc716a337e4c2c1da2db651b669565c3cc08e6a6074f28"
    sha256 cellar: :any,                 arm64_big_sur:  "db07a7c502116b5a80ae01e82e7f5c54633a8ac7343d369af25af6cc2c7e5bbb"
    sha256 cellar: :any,                 monterey:       "97126a03685c5538a9ddc95f1cae7f5b4ff9e7e7aba7fd8ebda0e2b48e76575a"
    sha256 cellar: :any,                 big_sur:        "56dd017876fd446d7283c7db7a6a0729eeebd34016094fdbf9f46b6711c0e26d"
    sha256 cellar: :any,                 catalina:       "5b30fe11d2ced21be876b56787e5d6900cb991fdd7e6ad3a6058401aa59ee9d7"
    sha256 cellar: :any,                 mojave:         "70c0928f2cb9034ad07c6242517ebc0e4cfb92b1ab74518f7b510a2ac36e81fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ff0fe65fb281d51dab44a53b15ef40ebeebf09a7f4d28e86dfc0cc18e49bbc1"
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
