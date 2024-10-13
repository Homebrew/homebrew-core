class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.8.0/libslirp-v4.8.0.tar.gz"
  sha256 "2a98852e65666db313481943e7a1997abff0183bd9bea80caec1b5da89fda28c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "469818c98320325537b527080018148b2a0890b538f2f860083cfd5ad54f5deb"
    sha256 cellar: :any,                 arm64_sonoma:   "6c4d57761e16cc3a1cd0a9c02147d28072e80159d38bdb90216e980d51deb265"
    sha256 cellar: :any,                 arm64_ventura:  "902f5a661dd64b96456aa93a61ba747f595a125698dc8d68d8652f2d3cfff33f"
    sha256 cellar: :any,                 arm64_monterey: "66223e420806ad8b140e331a2cc0eef4decff44367d0e3e5c35afe50e51be04a"
    sha256 cellar: :any,                 sonoma:         "547b399b0c5b850d29e9bcc9271527dc7f380576fc73b1d678f1995b0c0c7f4b"
    sha256 cellar: :any,                 ventura:        "9b05510f9439baf4f75d9d22e76cc06e98029706f624dbeb5c290e1003a317d6"
    sha256 cellar: :any,                 monterey:       "e1ea881475c02fac4b92e974fd0e638032a192d62d3fb9605e18f3347d1dcd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6f98589892ccd4d638809a454ecb06d8b6dc8dd4d87db9a27813bc1b30ccb4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Ddefault_library=both", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
