class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6da9a527b3afa7b1470acd4cd17157b8646c31a2c7ff3ba2dfc50c81ba413426"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f5a66d3f83cc1c539568a90675c0da2a65674af5b68f32e2c04763745bd7e5d"
    sha256 cellar: :any,                 arm64_sonoma:  "08a0433d4293dbee5e39420e62dcb598e56ca38a664645ae92674bbd1aed38aa"
    sha256 cellar: :any,                 arm64_ventura: "2b7d2684a14c0303fc1b83a6222671cc71c7b1e3122128ee0e2f7ecb78f5192b"
    sha256 cellar: :any,                 sonoma:        "aa207e4c785c6c68b1d9262b5c1093c42fc291b65013ad863beb346a302d9a67"
    sha256 cellar: :any,                 ventura:       "38fb8b2db3308dc8d9ab4d63d49a00ce7516104a1f08d6ff7fff0c6d1f04ea24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7777b9db275770b7a458765e3a3b28c1b82204e6a44831e519d1ddf2712ca3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb295d9cfe3986180f5c5c4e320b2dc5fb368fa2f5ca68fa13696755ddac37dd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh", "--with-openssl", "--with-tpm2", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libtpms/tpm_library.h>

      int main()
      {
          TPM_RESULT res = TPMLIB_ChooseTPMVersion(TPMLIB_TPM_VERSION_2);
          if (res) {
              TPMLIB_Terminate();
              return 1;
          }
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltpms", "-o", "test"
    system "./test"
  end
end
