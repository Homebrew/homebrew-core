class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.0/libslirp-v4.9.0.tar.gz"
  sha256 "e744a32767668fe80e3cb3bd75d10d501f981e98c26a1f318154a97e99cdac22"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41489d3292fc00e715930b65980adb384d23d248904c2a3ea126d6ef62c3328e"
    sha256 cellar: :any,                 arm64_sonoma:  "06992c7d810c3352be4d465c5551f37275063b9f927496c88754a4ed70075bea"
    sha256 cellar: :any,                 arm64_ventura: "d67c02807eab2c67b0fa0b6d60bcf945decbd1ec62d9586287d7966d34fb95ec"
    sha256 cellar: :any,                 sonoma:        "8729bdd5d982f8b5f61bd9ff63a9f6916040d28fd65a407ed1bc5d8891d0ecf5"
    sha256 cellar: :any,                 ventura:       "5a119322dedd978d5d6e269850bf5098d048a150a3689c9024561575a51368c0"
    sha256                               arm64_linux:   "5facd6fada8958aac92e7bff91f897f42f10169c834ff90d964e4bc53a68b6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80aef1df64bdf83980438cf320d2c8af65fc395d94a5ada48b97fa81f1a23f41"
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
