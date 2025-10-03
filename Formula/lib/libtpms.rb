class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "ebc24f3191d90f6cf0b4d4200cd876db4bd224b3c565708bbea0a82ee275e0fb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1415455064a8814adc7ba082a5288b70166d818b52bcc4b6313f0cb07cca510a"
    sha256 cellar: :any,                 arm64_sequoia: "15359aca8b873a6965f40e824368108637c9f8cf48b28fba6323f9752071023c"
    sha256 cellar: :any,                 arm64_sonoma:  "42a7c3f06554cb88deeff3b7b79ab082ed8eff5180ce06a0612a6f2b1191de95"
    sha256 cellar: :any,                 arm64_ventura: "19e27301de4d0e3be8f6e64d365fcea16829ddf004c4c2634fc8464e3a29ad11"
    sha256 cellar: :any,                 sonoma:        "8d898dc691972d2dc4a536f2f90608723593b2cccec3878c81a29f7524dac0e1"
    sha256 cellar: :any,                 ventura:       "74c6e183ed2cbbb2d453c422560cd77ea56a92f0f3fd82650ebb3e56633341fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06262b5d69c7ee3a6f2083b6d36afd63e9b4c051f53a8f842d9f5c377fb3b180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea4a8d8b452a7bb8f7a8fb9d50db91e964e3d9c656ba14475ed94a480bd2a12f"
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
