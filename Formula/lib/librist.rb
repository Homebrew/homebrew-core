class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.13/librist-v0.2.13.tar.gz"
  sha256 "84b7f9228b2e9f3f484cc3989faed037c423581971bddde28370f6e6f5a0e90e"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee2045ed1285bb38af920175f0ae53765e8fece0b96d3f0f68d8c3bb352dbcbb"
    sha256 cellar: :any,                 arm64_sequoia: "d743183d025ea6e02517e5cdda8092b04b5f1853c3429fc1ae270c1611be0cd5"
    sha256 cellar: :any,                 arm64_sonoma:  "983aaf846f3b095f91709c4d5e6d51328b80564a67e04d1a733f61c4644e0105"
    sha256 cellar: :any,                 sonoma:        "2512e6108f6fb9b0bc48dcd575238e024efa459c531b97a452a8881ef3f5a743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61cdf1f1ee7cd9e16cf7e9c70cff98f39a9574042e1e82ff82c673057ee8407c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aff18d029b1e16fadbcdf93fe4ae523b4b19127c97b04ba279438c141460c82"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "mbedtls@3"

  # remove brew setup
  patch :DATA

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "meson", "setup", "--default-library", "both", "-Dfallback_builtin=false", *std_meson_args, "build", "."
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end

__END__
diff --git a/meson.build b/meson.build
index 7143b8a..1047c47 100755
--- a/meson.build
+++ b/meson.build
@@ -44,13 +44,6 @@ inc += include_directories('.', 'src', 'include/librist', 'include', 'contrib')
 builtin_cjson = get_option('builtin_cjson')
 builtin_mbedtls = get_option('builtin_mbedtls')
 
-if (host_machine.system() == 'darwin'
-    and find_program('brew', required : false).found()
-    and (not builtin_cjson or not builtin_mbedtls))
-	r = run_command('brew', '--prefix', check: true)
-	brewoutput = r.stdout().strip()
-	inc += include_directories(brewoutput + '/include')
-endif
 use_mbedtls = get_option('use_mbedtls')
 use_nettle = get_option('use_nettle')
 use_gnutls = get_option('use_gnutls')
