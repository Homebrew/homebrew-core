class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.5.0/libslirp-v4.5.0.tar.gz"
  sha256 "94e1dea99b58259c25e3b1af1f6119419c0b4bcf1dc3d6566776c7aa2d7692f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c194843e4b0002808b5b7de69d68c50108e314ee907df514ec67f5046918fd97"
    sha256 cellar: :any, big_sur:       "82f89a12087d2c4f4a023d390b34a092339f7112bf4f32ad9bb4e157a0857781"
    sha256 cellar: :any, catalina:      "c2b9dca7029b6605fada2f34ea4cca91fece1959daa1cb9e970c2a3143d3b945"
    sha256 cellar: :any, mojave:        "d74adebfe1d982be140295e6f7ebc739fea376d7689cc9f21e6fa868097a3a3c"
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
