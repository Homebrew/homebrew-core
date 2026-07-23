class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.3/libslirp-v4.9.3.tar.gz"
  sha256 "ee698ca4ce05217ca7d520c7f0b1b1228fd7d32922dd32d1051c347152588417"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "264ccf41d333c01c38c7f0172533b5c4796fb02a256f5a03da9046bbb72bd284"
    sha256 cellar: :any, arm64_sequoia: "281ad61d76baf88feb111daf6f530cf1d1a5064818c732ee9be2bd0dd934dcb0"
    sha256 cellar: :any, arm64_sonoma:  "47aab98796ed9b099ca36bd7a1fad214ba4021ed79075efa31843969ee1a0ed0"
    sha256 cellar: :any, sonoma:        "e892180953972c9bb9f268239e4dddca1fd439b9e47a615645b6e3068da35a33"
    sha256               arm64_linux:   "6c7b27fafcfd6964bc3c259ad1d49f6528114e3129e6f4273db0b51b719f84c1"
    sha256               x86_64_linux:  "290c378aefa6b1ad2fb25f9e067451e8ab50030bcd7e857e7ff09a183970e3ae"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Ddefault_library=both", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <stddef.h>
      #include <slirp/libslirp.h>
      int main() {
        SlirpConfig cfg;
        memset(&cfg, 0, sizeof(cfg));
        cfg.version = 1;
        cfg.in_enabled = true;
        cfg.vhostname = "testServer";
        Slirp* ctx = slirp_new(&cfg, NULL, NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lslirp", "-o", "test"
    system "./test"
  end
end
