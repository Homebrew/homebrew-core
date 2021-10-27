class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.6.1/libslirp-v4.6.1.tar.gz"
  sha256 "69ad4df0123742a29cc783b35de34771ed74d085482470df6313b6abeb799b11"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "475c2d9ad2e1a2b44c52e9ea1cd5627d392adb216b8e9969d059a5e17d9dafc5"
    sha256 cellar: :any, arm64_big_sur:  "93fca2e4a0c689c366680a9b56ca0c90cb424eb8fb00136a170cea67e7919d67"
    sha256 cellar: :any, monterey:       "4738978c9d94ebd569757a5c4df3918bf7f8e2aaf75f9d04b63cafcb24b29064"
    sha256 cellar: :any, big_sur:        "120eb1362ba0645a96ace10153fb41b5669f0a32669947cca96b2e1b3108edd3"
    sha256 cellar: :any, catalina:       "fc267a6871f5459a38e174ffd519a3016c849b6c99c2bce2ca714c20b71ae1b6"
    sha256 cellar: :any, mojave:         "3a19812499b688c6698c0e50b1b0a567727cf9a5af26ed71ff99a412a98f1c44"
    sha256               x86_64_linux:   "e49c9b8b88c0f9cb434cac8b488d38450bc2b148f71ba934c7562437a5b46c58"
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
