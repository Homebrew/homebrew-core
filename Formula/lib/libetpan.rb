class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  license "BSD-3-Clause"
  head "https://github.com/dinhvh/libetpan.git", branch: "master"

  stable do
    url "https://github.com/dinhvh/libetpan/archive/refs/tags/1.9.4.tar.gz"
    sha256 "82ec8ea11d239c9967dbd1717cac09c8330a558e025b3e4dc6a7594e80d13bb1"

    # Backport fix for CVE-2020-15953
    patch do
      url "https://github.com/dinhvh/libetpan/commit/1002a0121a8f5a9aee25357769807f2c519fa50b.patch?full_index=1"
      sha256 "824408a4d4b59b8e395260908b230232d4f764645b014fbe6e9660ad1137251e"
    end

    patch do
      url "https://github.com/dinhvh/libetpan/commit/298460a2adaabd2f28f417a0f106cb3b68d27df9.patch?full_index=1"
      sha256 "f5e62879eb90d83d06c4b0caada365a7ea53d4426199a650a7cc303cc0f66751"
    end

    # Backport fix for CVE-2022-4121
    patch do
      url "https://github.com/dinhvh/libetpan/commit/5c9eb6b6ba64c4eb927d7a902317410181aacbba.patch?full_index=1"
      sha256 "33e23548526588b0620033be67988e458806632efe950a62bd3e5808e2c628d1"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "2f2bc6b0e25e04a695cbfb726a3cfcf699098d8bcb3f65341ce73bc7fe5ac2e6"
    sha256 cellar: :any,                 arm64_sequoia: "0f71f334cab29455274e4c1a1ea4db7d20eb8d3cd6f52a3380343c62f5473359"
    sha256 cellar: :any,                 arm64_sonoma:  "ba50402af4e428540093a35f7493abfa5061dba3a80063c8356af13278d6b0d9"
    sha256 cellar: :any,                 sonoma:        "6c780a96c2675aeb1dc3130c91a46f75e673e12ef3cc8a381d6973496a3ba361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "793b454d15058dc0ba62741b7e094e27f9f311bcd56ec7fed2e197011b54eb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8c5f3550de87ef79a8037cba4778e4d148581c4ef4b28353a3eb80cad9aa61"
  end

  depends_on xcode: :build

  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.mac?
      xcodebuild "-arch", Hardware::CPU.arch,
                 "-project", "build-mac/libetpan.xcodeproj",
                 "-scheme", "static libetpan",
                 "-configuration", "Release",
                 "SYMROOT=build/libetpan",
                 "build"

      xcodebuild "-arch", Hardware::CPU.arch,
                 "-project", "build-mac/libetpan.xcodeproj",
                 "-scheme", "libetpan",
                 "-configuration", "Release",
                 "SYMROOT=build/libetpan",
                 "build"

      lib.install "build-mac/build/libetpan/Release/libetpan.a"
      frameworks.install "build-mac/build/libetpan/Release/libetpan.framework"
      include.install buildpath.glob("build-mac/build/libetpan/Release/include/**")
      bin.install "libetpan-config"
    else
      system "./autogen.sh", "--disable-db", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
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
