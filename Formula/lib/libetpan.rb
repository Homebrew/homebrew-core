class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhvh/libetpan/archive/refs/tags/2.0.1.tar.gz"
  sha256 "a1bb4bde2791f09ff7ded771ec37584663e6af59e6e64a88dd86e98133cb1238"
  license "BSD-3-Clause"
  compatibility_version 3
  head "https://github.com/dinhvh/libetpan.git", branch: "master"

  bottle do
    manifest_sha256 "4f4287eb3e17c42a7febfde69689b0c4563b6edbccb260dab729a5e3f2f64549"
    sha256 cellar: :any, arm64_golden_gate: "f54cb00f9dc9aad2869255dc52313706cb6556fdf1dc29a2c059489df5861fb5"
    sha256 cellar: :any, arm64_tahoe:       "1495a0ea86e30d9c7e9d26783df0fe0f2e61ce2063863d018a397fedea79110b"
    sha256 cellar: :any, arm64_sequoia:     "d1070fccadc0ee59eaf8d81bfd6fd5945788820973ecdc939b1b68db5f4be6ee"
    sha256 cellar: :any, arm64_linux:       "997df26776a862d30b813a7ba9e5eb785c7f087cfc0bb17cfdbdb711c4abdff2"
    sha256 cellar: :any, x86_64_linux:      "aa4a1db7b3c4f8fe1d173b53074612d11bb19edfe57e540073a70a099d582dac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./autogen.sh", "--disable-db", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libetpan/libetpan.h>
      #include <string.h>
      #include <stdlib.h>

      int main(int argc, char ** argv)
      {
        printf("version is %d.%d",libetpan_get_version_major(), libetpan_get_version_minor());
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-letpan", "-o", "test"
    system "./test"
  end
end
