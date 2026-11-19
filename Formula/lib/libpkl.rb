class Libpkl < Formula
  desc "C library calling into Pkl's message passing API"
  homepage "https://pkl-lang.org/main/current/libpkl/index.html"
  url "https://github.com/apple/pkl/archive/refs/tags/0.33.1.tar.gz"
  sha256 "1e244cff4c27cacf800a7db5efeb3c2709364556e67e37bb8369705db49a7a1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0fe1b982b9476c980a9ff6fcceb3e24e95a39248243aee363e50842652e090e9"
    sha256 cellar: :any, arm64_tahoe:       "ba0219910d57f56a3170cdf0e1e01ce9f1262e6f3f891d48a5835a105d7ecef1"
    sha256 cellar: :any, arm64_sequoia:     "3daaa3113dd6226cdf3135126aedba79152d396f5c8c64b3903b832651d77256"
    sha256 cellar: :any, arm64_linux:       "a3022a874321edc84e0f0b968f34cf155639d32e232506863d637eb90f7fb921"
    sha256 cellar: :any, x86_64_linux:      "ff811ee7d20eeb300eb244a74fd33427c4cd8003bc2b1c50481c91044d337e39"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :test

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    args = %W[
      --no-daemon
      -DreleaseBuild=true
      -Dpkl.native-Dpolyglot.engine.userResourceCache=#{HOMEBREW_CACHE}/polyglot-cache
    ]

    system "gradle", *args, "libpkl:buildNative"

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    os_name = OS.mac? ? "macos" : "linux"
    native_libs = "libpkl/build/native-libs/#{os_name}-#{arch}"

    include.install "#{native_libs}/include/pkl.h"
    lib.install Dir["#{native_libs}/lib/libpkl.*"]
    (lib/"pkgconfig").install Dir["#{native_libs}/lib/pkgconfig/*.pc"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <string.h>
      #include "pkl.h"

      int main(void) {
        const char *ver = pkl_version();
        assert(ver != NULL);
        assert(strcmp(ver, "#{version}") == 0);
        return 0;
      }
    C

    ENV["PKG_CONFIG_PATH"] = lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs libpkl").chomp.split
    system ENV.cc, "test.c", *flags, "-Wl,-rpath,#{lib}", "-o", "test"
    system "./test"
  end
end
