class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.11.1.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.1/libssh2-1.11.1.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.1.tar.gz"
  sha256 "d9ec76cbe34db98eec3539fe2c899d26b0c837cb3eb466a56b0f109cabf658f7"
  license "BSD-3-Clause"

  livecheck do
    url "https://libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec865686b712ca3eeee298124d08aacce8d6b67e37ba6e1bd8499fbce13a5ad3"
    sha256 cellar: :any,                 arm64_sequoia: "4fd55e8973a9454001ac289972767ca8927f3639aa44715aa1e9ba81c3712245"
    sha256 cellar: :any,                 arm64_sonoma:  "2e6ffae575cf6e8335026f209f24c8a12250afa093e7a49577ee95c3bb781554"
    sha256 cellar: :any,                 arm64_ventura: "f1a9194b318669ded3d72a045c1cc30b4ce53dcb23a0b5953910f6dcd341522b"
    sha256 cellar: :any,                 sonoma:        "092a33680301532d2ba966e85b3316198d65891a0aa6211d616575cc82bbd09f"
    sha256 cellar: :any,                 ventura:       "b34913dfb88d186400ec06e9beff6d81824c082c5920c88737df980ca9b602b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "583976433ceba6667dec4452c6533fe4c10d0343b082ac683cd1b8407cbf76fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a307208b03d0761f7ea8c53a322ea09b0a60db96e3ef8688df6adec92b45ca5b"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@3"].opt_prefix}
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
