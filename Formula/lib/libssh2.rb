class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.11.1.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.1/libssh2-1.11.1.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.1.tar.gz"
  sha256 "d9ec76cbe34db98eec3539fe2c899d26b0c837cb3eb466a56b0f109cabf658f7"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b435df4f6ec7e67cff3f37ebac8cad358d3ca42711a818530530470cc65595fc"
    sha256 cellar: :any,                 arm64_sequoia: "77fcd30972333f681544cb8fee68818fc6652029ec4e3efa0724ca60447e9881"
    sha256 cellar: :any,                 arm64_sonoma:  "34927ad08cd265d32f1390a92d84451f85ab5b2f28101ca951da3d3e9df12047"
    sha256 cellar: :any,                 tahoe:         "e78effa726d2b874656684a29acf0991dabc1a0c7833df43918883a90a06c5e5"
    sha256 cellar: :any,                 sequoia:       "004683da08b3ee0b01d9b64732e8ccc5158a3d6d68963028177a1a97e47de77a"
    sha256 cellar: :any,                 sonoma:        "1f270e8ce9bd56c4d7b894d385e04912c64b53be1402d25dfc8b6d7e01521176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c46480fecd2fe0291afd9957316d6485179b050624dcb6b21753eacab3b28c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d8d069827f2d1b395fd2edf20d5df3dd88e8c45d9db330d293004d70a7413f"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
