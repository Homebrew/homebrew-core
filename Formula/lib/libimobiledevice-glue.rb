class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.3.1/libimobiledevice-glue-1.3.1.tar.bz2"
  sha256 "6e2849f221e6ab970566a115d42f3c20f8848e4d40c2ed61ac20dc85f40fa54f"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b64aec0201f725ffa387c7624dc8690ffafd802e01117dcdda3f335b349b99ce"
    sha256 cellar: :any,                 arm64_sonoma:  "131bac1d6f7a2f4044b445e956ad7f5fa82d0e3a6b9a6a0230393d7f1c45c910"
    sha256 cellar: :any,                 arm64_ventura: "a3d210d9d3d98e8919561754030ff00a6735275aefa65be7d0ece3b29a62164a"
    sha256 cellar: :any,                 sonoma:        "393c65ff96685188dc9b646e1342379988af3494297052fb23c8f5e49aa5d8d7"
    sha256 cellar: :any,                 ventura:       "a2022bc720c9aa8caf0c61d4bd9429be8ecc009ac1eaf4dcb5c0ece40be2e7b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "998f89f012b920eb63abc2a056f87a4f6187a97c6b9442375c9adef02a33857f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91fd81b54b2c9d6eee333204b752b95aa05ac95779355a573a03bc12632e3daf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    system "./test"
  end
end
