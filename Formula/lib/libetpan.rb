class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhvh/libetpan/archive/refs/tags/1.10.tar.gz"
  sha256 "0ca9a79f66155e12156727856a40031030f5760f7bc88b29119e851b9c96e9eb"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/dinhvh/libetpan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b751456b516ad4ce3d15e75053ce2c13693f250f84f4cc339fbd6d4d491cd0f"
    sha256 cellar: :any,                 arm64_sequoia: "bc76e7458e319ac837174b9877b4e17492239a9fc52c475aa9ceb34d99b577d6"
    sha256 cellar: :any,                 arm64_sonoma:  "12e8e61a77ad429e2e4dc7163dfa1c8380055233d8364711072da63d15212916"
    sha256 cellar: :any,                 sonoma:        "415116a3745329af0cf70b55c94a899683f62508875c6ab7b974e63ee99e726d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e0e49c2128bdae30a97860512cf0bcdfdd1299ddc461f44749e68d28b086a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9632a4d8a0e8d5d99b5f6be7b5315109594d2543749e3e89e16b44e314ca132"
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
