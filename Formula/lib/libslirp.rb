class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.1/libslirp-v4.9.1.tar.gz"
  sha256 "3970542143b7c11e6a09a4d2b50f30a133473c41f15ed0bdcc3b7a1c450d9a5c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "18d81f7392c77441d299e5ea36b08c85553919f407fb5433fb009c032a099b39"
    sha256 cellar: :any, arm64_sequoia: "12a9e671b10f09a59a51c9eb9010baa5d5a787f8404ff7a3ed709444ccd6c1c6"
    sha256 cellar: :any, arm64_sonoma:  "9f5be8a2ff62099f8eedcb100f94ba8d0738f6ac4b0f2008672f61115c0a73c4"
    sha256 cellar: :any, arm64_ventura: "4fc26d7834da55420b1c52fc3485af3a5b9185011c4f279890fb191450acf359"
    sha256 cellar: :any, sonoma:        "ff2054700a614d655e435078c3893cff4af6df3ac42790ed47ffb2e32c266e44"
    sha256 cellar: :any, ventura:       "0697734d15f13ff118f98ed958203810b089b67e0e3e2495b253e8cd8158eb77"
    sha256               arm64_linux:   "15990492fa251d8234d1e03dca795409da45482cc49ffce227922c1287de1b5a"
    sha256               x86_64_linux:  "ffa7400789bef355d7d42bf479655ca8de737e514f8ae261a6669b128404903a"
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
