class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "61d6f947a60686ec98e7cc5861f0999bd6cdaa1fc2b8901b8dc68d1a715b35cf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8a48503bb9da6bdae259aff0741fa60450d16b5bf4479ab563902690beb1b465"
    sha256 cellar: :any,                 arm64_big_sur:  "1ec5517ac5f11558be019a4ad665425f7a12d32147ad4a46ea8671c21f382e73"
    sha256 cellar: :any,                 monterey:       "02626f82bd03e56529ac1100863ad90bf2bc3a24ed18a3d32c63e934b8bf0a33"
    sha256 cellar: :any,                 big_sur:        "46790d698b4f77fc569cc0bba1fc7f0405a9e1198c8d875f8ffdd3eb27b8a625"
    sha256 cellar: :any,                 catalina:       "3200e3ebfbf594e2b86d53b465ad119dcbbb26f28919285cccd322dfb34d80a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc40ae95dd6b50c74e4915024af0b580f6f9f35a173a139894f2e072a038bcc6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh", *std_configure_args, "--with-openssl", "--with-tpm2"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltpms", "-o", "test"
    system "./test"
  end
end
