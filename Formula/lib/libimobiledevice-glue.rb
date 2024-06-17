class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.2.0/libimobiledevice-glue-1.2.0.tar.bz2"
  sha256 "ff9cbc240c9780edfa43914a057b86362054053721b65fb04f54a25023b92b62"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5e00139aad86809adde7ad17bceeedda2a3177372df04fbe9a91bc3fa1366a5b"
    sha256 cellar: :any,                 arm64_ventura:  "005fde87e6014290eb3c9e08712b6dc93dc3febf2d56c44094f37f34fe149d10"
    sha256 cellar: :any,                 arm64_monterey: "f433d2bd7a0f0af23fe462fcd8df88e87fc0c8f908d92c7f67a4a2f7a320a441"
    sha256 cellar: :any,                 sonoma:         "a248f4d3c9fdf4608e941d818317e5d86c2132c1140daa45bbf6a82f8f90a53c"
    sha256 cellar: :any,                 ventura:        "4580c48aec859791cb1771caf7ff609f09af8a4d9352883d1b104d6039cb193b"
    sha256 cellar: :any,                 monterey:       "607706dd2f6675ee2ff5900fe82ae1b666e10bb17892eb9c2b5ba9d3391219b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c30c5964567df2dcb1b86e70e41622aaf72d533effecc6ee0ef7348171eefdd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    else
      system "./configure", *std_configure_args, "--disable-silent-rules"
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    system "./test"
  end
end
