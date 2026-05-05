class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.11.1.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.1/libssh2-1.11.1.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.1.tar.gz"
  sha256 "d9ec76cbe34db98eec3539fe2c899d26b0c837cb3eb466a56b0f109cabf658f7"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1

  livecheck do
    url "https://libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c72e9377d6e69d19c7fa3bc10fb47543441ccbdfd170943ef2616122c6b6d5e"
    sha256 cellar: :any,                 arm64_sequoia: "95639cd69d3ec90acde6614d7586968c51e993042ad13ec80317873e7910ffe6"
    sha256 cellar: :any,                 arm64_sonoma:  "02eff02b1668d1fe573733c4a163b1752fc1e891cec93358dd08d9d27c0a4651"
    sha256 cellar: :any,                 sonoma:        "42d0dabb27268b9971cf7ff4369b3dfde790c5fc6d0118f8a79637a703b5514d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed73f3be04f4a9c1e64b0a08363b3f0bcd681afceadd02b68ac1a4105e97a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d5b6a4bba440ffe03ecd9cfde89a8958f496f7640ed13493639a71309a8ee46"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@4"].opt_prefix}
    ]

    system "./buildconf" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
