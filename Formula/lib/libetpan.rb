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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "08105297d438c57ab65bea17b296762382703126bcd033627a01b0d2a26312ce"
    sha256 cellar: :any,                 arm64_sequoia:  "28a0fa384fbe4f86bed68fea326d1cdfec1b4fc8c0b21283a00e3c268630f503"
    sha256 cellar: :any,                 arm64_sonoma:   "eb5765b64ee9833f052439c9f5b29752115b84761e569c7d7d07d35b457fe5a5"
    sha256 cellar: :any,                 arm64_ventura:  "daed620aaf4d24519d79be6cf34fdbf52386fa92c4c7880e8cf05cdccb0a787f"
    sha256 cellar: :any,                 arm64_monterey: "1d33d9e801085b4c350423a936c7e79d1b6ed20b1bd0cfd08d42ae5e5274f07d"
    sha256 cellar: :any,                 sonoma:         "a025d5684d2edc67c1b50b04ed4fab5f8ff5534c6a3c5b4093f5cf84837b46a0"
    sha256 cellar: :any,                 ventura:        "143a977a506121a0b96acdcd4364ab55e278b2d887ab1e28f85d59c81e86e116"
    sha256 cellar: :any,                 monterey:       "0803fa89cfe96b599bc4c811707872971b94c297e353032d614797f614bc90bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6b77f7345d0e27f4cbc5339afc734e0a897056111c1f79fc949c9d90b8ca66ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c3a249c5498bb7b6b9fcd5f735b9ca04e3225b8654a72464f457506c6aa72e"
  end

  depends_on xcode: :build

  uses_from_macos "cyrus-sasl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
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
