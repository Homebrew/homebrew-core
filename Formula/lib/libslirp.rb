class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.9.4/libslirp-v4.9.4.tar.gz"
  sha256 "3998863b020aeda34bddc567097c6efba55a78cdf6eeee6bcd42c11ef23967da"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f24148638d099d7c11b64a73a52fd80d8510a1352c7b0d8f3ada6d92848d503"
    sha256 cellar: :any, arm64_tahoe:       "85933cddee6ab6b7bd3de70d4a00b22ee54482bc77c24fd6061787dc6e5e0c2a"
    sha256 cellar: :any, arm64_sequoia:     "78dc33e108213bceb8f4b8a9d0293c0ff578a806ace4dfc4199af8c9714a2ffe"
    sha256 cellar: :any, arm64_sonoma:      "e15efc0fe9723daa55244be80ebbb3e62b7530cc8d7be1c6ac62fbd229ee740e"
    sha256 cellar: :any, sonoma:            "9f0d539814503d22bfdf171064372fd4b2b5cc777fd5128cb81243e49f60d8c3"
    sha256               arm64_linux:       "592da2491c816e9e97a3eab49789e8af2dcf611ba824999b63f15dfe40543652"
    sha256               x86_64_linux:      "7767c469e12306692839f22e506127f793746b0ce5d44e37cbb8dff43c63cb58"
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
