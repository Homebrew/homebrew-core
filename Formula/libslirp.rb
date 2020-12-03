class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.4.0/libslirp-v4.4.0.tar.gz"
  sha256 "43513390c57bee8c23b31545bfcb765200fccf859062b1c8101e72befdabce2e"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "51817f70add83d1fb74dd233d683aa88e3d0da1e9f8df5c724347e946c2bad6d" => :big_sur
    sha256 "1b810179f0b4978a6b06f15156b8f4ecddd7b7b8408e61129a11913cf9ac4145" => :catalina
    sha256 "d708a39f70d01586c4d9e6fcccd832f638b07325424ce451418bcaee68688669" => :mojave
    sha256 "a7c30a50420febf21f5969719f1d7d9a0abee04a79586c951799212cb952cb9f" => :high_sierra
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
