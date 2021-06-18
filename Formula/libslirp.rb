class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.6.1/libslirp-v4.6.1.tar.gz"
  sha256 "69ad4df0123742a29cc783b35de34771ed74d085482470df6313b6abeb799b11"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9f2e35cd0ca207f33cad11d421509ac7c07430f1ab2297975bcc37cb5e7ffdff"
    sha256 cellar: :any, big_sur:       "d1a5e21056a3e549feb9eaf6062a837e7627a2d06163e18e3ff84f7cd27508ea"
    sha256 cellar: :any, catalina:      "0217c0ff05bd25096aa219d4936aad3182b1cad41887434eeba02d5e0f0c4280"
    sha256 cellar: :any, mojave:        "0c2b2a7c49e23354ce4c9717ad7fb52f0d60f40012725fd1c1055eb9fca31871"
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
