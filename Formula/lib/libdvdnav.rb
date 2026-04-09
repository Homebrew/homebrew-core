class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/7.0.0/libdvdnav-7.0.0.tar.xz"
  sha256 "a2a18f5ad36d133c74bf9106b6445806fa253b09141a46392550394b647b221e"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvdnav.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdnav/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de06e1e44ed91415e861f0bd79e41de8136e9786fc430d4cb81b46be8bdc9643"
    sha256 cellar: :any, arm64_sequoia: "572d32a3743e5b4aa64e8db20ebe4c524709229e167247e7563063d4d4a1fe43"
    sha256 cellar: :any, arm64_sonoma:  "0fd026d465fda11f3b47ebe709f5c31efe1e74fd862a1869f14f51697d54ef35"
    sha256 cellar: :any, sonoma:        "05fc8e61a4945df5d16c96014062b79477a44a271b4371398f5c9f91a526fe71"
    sha256               arm64_linux:   "18d641647018fcea9fac4d0bc26bf04aa8a47ef5206de9bdfa91af2d23f9ebd7"
    sha256               x86_64_linux:  "013483294308424c90b6d2cf46335160df2f5ad9d2a12935d8bb0e12669d28d7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libdvdread"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdnav/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDNAV_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs dvdnav").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
