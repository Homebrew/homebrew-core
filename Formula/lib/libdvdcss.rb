class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.6.0/libdvdcss-1.6.0.tar.xz"
  sha256 "7ea556c846b7bfc32d47b41cae56d1863a6b6d5f706bb162778d6f298490977c"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvdcss.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/libdvdcss/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb4858cde27c4653a31994c596f158eb2c3d11bf72657bf2774e69f91a253835"
    sha256 cellar: :any, arm64_sequoia: "d3753d4f5e4d4fb74e2129125bf1d5931a61e47ce199010ab55ffd8c27ab9958"
    sha256 cellar: :any, arm64_sonoma:  "4560b04eac977d1690f7bffdfffdc16c5663e11934a843a6d9fba71cdba19bce"
    sha256 cellar: :any, sonoma:        "5cc8e9f4b6fd724d386c09ff929de0ef5248c5aceb642bfcd0b5e2dea23c2634"
    sha256 cellar: :any, arm64_linux:   "e1a61b023693faa0214fa081db8f9ccd19059025cc8a629440c428455afbdd1c"
    sha256 cellar: :any, x86_64_linux:  "cb4086087962774bd1c9f95f4209447549e8f9ab1a19b1d38d10a1072902c99a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdcss/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDCSS_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs libdvdcss").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
