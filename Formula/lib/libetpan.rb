class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhvh/libetpan/archive/refs/tags/1.10.1.tar.gz"
  sha256 "87bacdc62661a2a7aa5fe9f1f28d2f7c7a53256633ac5129903916c59f80c4c2"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 2
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
    if build.stable?
      odie "Remove workarounds!" if version > "1.10.1"

      # autoconf 2.71+ probes -std=gnu23 first on modern compilers, which rejects K&R. Force gnu17.
      ENV.append "CFLAGS", "-std=gnu17"

      # https://github.com/dinhvh/libetpan/commit/9919beeea09850364ea966b0d9fb640858bd2b27
      if OS.mac?
        # Keep macOS-native TLS (CFNetwork/Security) compiled in.
        ENV.append "CPPFLAGS", "-DHAVE_CFNETWORK=1"
        ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices -framework Security"
      end
    end

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
