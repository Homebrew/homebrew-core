class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "2807466f1563ebe45fdd12dd26e501e8a0c4fbb99c7c428fbb508789efd221c0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18d9b36805fcc1f2012982c711a1da47ccead50abf72f8821f200a5613514aae"
    sha256 cellar: :any,                 arm64_monterey: "8bf44aec280307aac703113793bf17627e72b313d11f3e7d4a9a50a2fd5fa589"
    sha256 cellar: :any,                 arm64_big_sur:  "a29e5d9695b2f96546395d0fd3bd96cf35a8060794b0dbc185798cf951e927e3"
    sha256 cellar: :any,                 ventura:        "bbbb8d1d4b6bec02c83bef2b7023c2892008dc935e76a8a7f7f55ef80ebe38cc"
    sha256 cellar: :any,                 monterey:       "ac8d865ac40e7aa31a7b48a690ad9f90dd730e5a45534977a3ab47806fc1dc52"
    sha256 cellar: :any,                 big_sur:        "b5f88fea923c10778e6a8b1bcfbeaf20b4aefca06b74e2300675d1589c6dc928"
    sha256 cellar: :any,                 catalina:       "65027022918ce5a232156876f48c90ea4e7cc19c5fababf43089cec285009da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7b38dcbe252db9c6737b254fa9f642fc1cdac57e3c6859c1dcdf67876fb7962"
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
