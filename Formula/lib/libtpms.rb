class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "edac03680f8a4a1c5c1d609a10e3f41e1a129e38ff5158f0c8deaedc719fb127"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66fd464e0e778e9d1c3bfff440e5f280891e5eee4d58e2c536a0d855bda23116"
    sha256 cellar: :any,                 arm64_sequoia: "0439dcadfc4c140158d1a5d7f63c7ffeb3fdc69b4e90943c422e3d5de7664a7e"
    sha256 cellar: :any,                 arm64_sonoma:  "112fd1f45e4a807f37a3e1cb29039e767c6d202d06209387ae484502d79775de"
    sha256 cellar: :any,                 sonoma:        "f066899b2329dd5224682c03485d8f376538f888d443f4efa411cbb2ad5d01fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9647eaa61b0021650f0d1f7bf6f9d6dce81d4df1cf33cedbc2de1315e99035d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8726633ed87a22297c0943d83329308c0e9187496cfdab7c322789f536e8a4b8"
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
