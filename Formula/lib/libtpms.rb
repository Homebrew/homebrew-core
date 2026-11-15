class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "edac03680f8a4a1c5c1d609a10e3f41e1a129e38ff5158f0c8deaedc719fb127"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8335ea28c832407e001886232c1fdd6e45da78a314a6dc812efc96da4504946f"
    sha256 cellar: :any, arm64_tahoe:       "8407b49b8507d71716c2d7c63624448922c5b30284924811e815233318e6eb1c"
    sha256 cellar: :any, arm64_sequoia:     "d3fc62db2d34cd269b402be7e1a4f2a9742b638be26ea4f3b1a640813271e10a"
    sha256 cellar: :any, arm64_linux:       "a772f0538372e126fe0bbe248975a1a1d0fb52c90e8eb1a8424eb82c3af7da3b"
    sha256 cellar: :any, x86_64_linux:      "8db8a3c599ca72a621c67ca109d2e39a1ca8db238cd9ed9e78f6f77bdbbefd2c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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
