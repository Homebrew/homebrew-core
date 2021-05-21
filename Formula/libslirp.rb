class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.5.0/libslirp-v4.5.0.tar.gz"
  sha256 "94e1dea99b58259c25e3b1af1f6119419c0b4bcf1dc3d6566776c7aa2d7692f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cec97ae53546763da4c377038f43c5a72d2ed14288a0c13441a57ae419bd0ac2"
    sha256 cellar: :any, big_sur:       "911888d8a0ac274363a629b94c07d7b46d2b1eae5fdbf1131f95b0f16684d45a"
    sha256 cellar: :any, catalina:      "f168f09b9cf07d04dbb1a1d5d1a6f5c845a00ace46388ba366846fdcacee7e45"
    sha256 cellar: :any, mojave:        "4dbfe6f24dbac45a0c5d2796d350752ea25ebff528f0ccc1e29f3d476ec51104"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "meson", "build", "-Ddefault_library=both", *std_meson_args
    system "ninja", "-C", "build", "install", "all"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lslirp", "-o", "test"
    system "./test"
  end
end
