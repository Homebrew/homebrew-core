class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhvh/libetpan/archive/refs/tags/2.0.1.tar.gz"
  sha256 "a1bb4bde2791f09ff7ded771ec37584663e6af59e6e64a88dd86e98133cb1238"
  license "BSD-3-Clause"
  compatibility_version 3
  head "https://github.com/dinhvh/libetpan.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "039ccd1b8023805c44efd0942439df0523ee8a555c80fc8b7fee728aaa1dc0d4"
    sha256 cellar: :any, arm64_tahoe:       "2be23cadc5d1f3d5ca985765bb42d3cb3be90423625d302c27ffc31205aea892"
    sha256 cellar: :any, arm64_sequoia:     "79ceb36126152151472816c72c5b188b7aa5f973677ec86345e45bd539b1e5af"
    sha256 cellar: :any, arm64_linux:       "85c7525625658e477f6685307ea781c108e34a8a1d44e7f45994b93a7446274b"
    sha256 cellar: :any, x86_64_linux:      "6e7d3988cc9551d976a7cfaeb739117a3b2cc5e5f675b102e69ee3c3c08d0d07"
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
