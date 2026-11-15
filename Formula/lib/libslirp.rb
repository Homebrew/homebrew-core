class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.7/libslirp-v4.9.7.tar.gz"
  sha256 "d2567fa06a6357c7755d61c67293b2c0bf069b3f2173bde6b76cf768529a1938"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5081aebdcf1a0c08f2b7bc92c2279c2a7b9d93650c2ba54d421aac888c67e935"
    sha256 cellar: :any, arm64_tahoe:       "4a5b0100041e92a6b61b01cb7b393b76c7a9a1391d706e7da52267507f004535"
    sha256 cellar: :any, arm64_sequoia:     "c42971e7df9e9a58df62547c10ce1621ec994db2fd274e21692680b11b538432"
    sha256 cellar: :any, arm64_linux:       "501bc6bfbb89b2eb9cce5186b3275cb4a12214f36dc4d399b9105ba690cbd83c"
    sha256 cellar: :any, x86_64_linux:      "74ddb28a719477e19713edc0ba386f928b31655fba284e4b2db0f38b3b336144"
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
