class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.0.0/libimobiledevice-glue-1.0.0.tar.bz2"
  sha256 "160a70e2edc318312fc40b6a71f85bfdfabdfba10bcfc5bb6fb40ed95088f4a0"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef2149f0101eb75af1efc6937503454158b0abdfc1cec1f34e812e2ac7923f7a"
    sha256 cellar: :any,                 arm64_ventura:  "d0075ad2928c0d58bb082a560ed98d99cf707ec7aa38468dcd2a8de7e4318e2c"
    sha256 cellar: :any,                 arm64_monterey: "2df780fb2c3db6fd9ef4d2ce93bf7485ca048835684fa6c52f4cabfcd6ecde5b"
    sha256 cellar: :any,                 arm64_big_sur:  "102c5bfea819697a98424e60a2d7ac144a29cd3bacd7b8985aa145b7cf3fe2f9"
    sha256 cellar: :any,                 sonoma:         "2e80b8aa3d5627f2a6f496f882254511cd7dc07803d933df2398d43604f8d89f"
    sha256 cellar: :any,                 ventura:        "b54a189cad02331e9d9260f62bfacfc5479cb8751029f4911bb26ab817cb7789"
    sha256 cellar: :any,                 monterey:       "e4bb7b80e1f4c1c9e49da748805534f77f153f92549db058cc6b15e2d07aae4d"
    sha256 cellar: :any,                 big_sur:        "f56f9258d3653ebe550079fbd4db06c0d6d65e5f944bbb072d5874e762212434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df3bb9fa34708bddc165c568ed80517235e5813dc7640843ac28380ef39bec6"
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
