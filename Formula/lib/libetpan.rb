class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhvh/libetpan/archive/refs/tags/1.10.1.tar.gz"
  sha256 "87bacdc62661a2a7aa5fe9f1f28d2f7c7a53256633ac5129903916c59f80c4c2"
  license "BSD-3-Clause"
  compatibility_version 2
  head "https://github.com/dinhvh/libetpan.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d45c5e4ad86f299c6ce0d66f4abbf970c8a1cb40d6788bb22a5e684a22ba28e"
    sha256 cellar: :any, arm64_sequoia: "f0c7a9dc8202d2a608fc1498111ca6734f841dc39d9510d0754585e9b219b033"
    sha256 cellar: :any, arm64_sonoma:  "99f5b95a2432b732f1422ff5ef45004589eb82762e75b98489a091f1ce7a402e"
    sha256 cellar: :any, sonoma:        "0eb588f25e71265e87938f709a5f1940b9419699d419952e40869bb152054d31"
    sha256 cellar: :any, arm64_linux:   "9cece4a93d0d34b081eee3941d51f0f044a2df21b04a9322c4d4d8e874e63190"
    sha256 cellar: :any, x86_64_linux:  "efa0be8eae32c23f04482fe8dfee6b403b7b5eeb21e0560304a136d41b39a365"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # autoconf 2.71+ probes -std=gnu23 first on modern compilers, which rejects K&R. Force gnu17.
    ENV.append "CFLAGS", "-std=gnu17"

    if OS.mac?
      # Keep macOS-native TLS (CFNetwork/Security) compiled in.
      ENV.append "CPPFLAGS", "-DHAVE_CFNETWORK=1"
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices -framework Security"
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
