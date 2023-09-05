class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.7.0/libslirp-v4.7.0.tar.gz"
  sha256 "9398f0ec5a581d4e1cd6856b88ae83927e458d643788c3391a39e61b75db3d3b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3e461de89cdcc48cd88ed8065700575cc3d4921213f2023cce1c1c56853c9117"
    sha256 cellar: :any, arm64_monterey: "dbfc3fabef1a14eb7807e97bac7e318dbf0ca0ac631cb949cd165ca79c57d16d"
    sha256 cellar: :any, arm64_big_sur:  "7ff75ad4ca2b56e4df3f139c1a265d1198174b676856f5eb019730d8f97db557"
    sha256 cellar: :any, ventura:        "e7e395084378af6bbc0582807938b023cb513cb5c99673b59c462429d077c25f"
    sha256 cellar: :any, monterey:       "82fe4e66ac490e882aaf245d4bdf9382826d82fdb3c7bad29b7dc4e77a5b8657"
    sha256 cellar: :any, big_sur:        "3b31c4120ac2abad0cb5480576b957d5dd335e9a7cfa4cea0ef7bcd27e6cdcc6"
    sha256 cellar: :any, catalina:       "63ecdea6ce7b3784bab8f2aa956468a1b90c67bb5e466afd80ff8ecadfe4f09f"
    sha256               x86_64_linux:   "dda8b4369eada1f246aebcc4f013966dfac010cb84045a5b80e034d9a725f582"
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
