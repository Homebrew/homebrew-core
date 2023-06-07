class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "2807466f1563ebe45fdd12dd26e501e8a0c4fbb99c7c428fbb508789efd221c0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2f02f188732ed0e4087d9b42884d105431643c3cb8159f393775ca7e5758123"
    sha256 cellar: :any,                 arm64_monterey: "36a2c1eaec30621078ca68543253eb22e26c82d0268044a290ffb7dd1df12b31"
    sha256 cellar: :any,                 arm64_big_sur:  "31f91991e4be84723105b06070cba57ec75acf9868f239a8d8c4a1ba4056d288"
    sha256 cellar: :any,                 ventura:        "b9d7bb7a259a45a826d4c8ddbb13563598a789d9b1124dc3ac9dd6d58f7fca86"
    sha256 cellar: :any,                 monterey:       "739007871c7bfd3697c0640a0d9bea612dccfc2a4310877f203d64d40fd3a80f"
    sha256 cellar: :any,                 big_sur:        "1e12100af9f666d5830c0b3753024af7359b5aef600408813ff3f43de7f7126f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0feb0b0c82a34761e619248ba87e2b994552b0cc60e06dea00ea6dfccc735a"
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
