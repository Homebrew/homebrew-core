class Libtatsu < Formula
  desc "Library handling the communication with Apple's Tatsu Signing Server (TSS)"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libtatsu/releases/download/1.0.4/libtatsu-1.0.4.tar.bz2"
  sha256 "08094e58364858360e1743648581d9bad055ba3b06e398c660e481ebe0ae20b3"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libtatsu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3490caa14c81cdffce28d50ce34880ab9b95a193a26906bf035492e3c37a3b2d"
    sha256 cellar: :any,                 arm64_sonoma:  "870c73a45691c13d672235e9a3ed53d0a9d76a7f1b9aafda775b541c1735c3d1"
    sha256 cellar: :any,                 arm64_ventura: "4a33d3d2692d953e3bd1c0a8561011152ab9dcb5d029f0bbc33315233337fe52"
    sha256 cellar: :any,                 sonoma:        "fafd0d67b5ccd44ee5c33fd4ba38f063029a89582a21e5a88104f00638bc620f"
    sha256 cellar: :any,                 ventura:       "70223395b5fb5525f701e78c40b9b5b4c9f897fec98bee2dff4af63612440da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84fd9c2fef6f7311c1b68ab8f1c481ea0e80cfc6ceffc1bef0dd23ff38e4c5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd96d83e2a85b4c479893f9493d0ffb9d7f66d357216d08adb6a4a158f72a582"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  uses_from_macos "curl"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libtatsu/tss.h"

      int main(int argc, char* argv[]) {
        tss_set_debug_level(0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltatsu", "-o", "test"
    system "./test"
  end
end
