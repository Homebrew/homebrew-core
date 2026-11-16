class Libpkl < Formula
  desc "C library calling into Pkl's message passing API"
  homepage "https://pkl-lang.org/main/current/libpkl/index.html"
  url "https://github.com/apple/pkl/archive/refs/tags/0.33.0.tar.gz"
  sha256 "b232e7149705f4f4922dd27d4693c9ea97fa32b3fec9d45ef6f3297dccf2858c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "df75bfe73dd3c8ae1482467bfadfb78eba69fb0d3528818afc08f863fc147556"
    sha256 cellar: :any, arm64_tahoe:       "cc509280766edeb6ec0961079c793289d84b06f7df9998ed82ab5d3aee752dae"
    sha256 cellar: :any, arm64_sequoia:     "241d65492170ff67b31a60c7f436909d12e386db2106b91cc9a68192f08c45b9"
    sha256 cellar: :any, arm64_linux:       "4171bac15424ee4de38ac0e0a309e8ae08f85da1bf76eaa202e9e477bb0a1566"
    sha256 cellar: :any, x86_64_linux:      "0e952d7e69337a9c994e30d06f1f012337894516a41f31aad5def7b161bbefd5"
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
