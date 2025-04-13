class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.11/librist-v0.2.11.tar.gz"
  sha256 "84e413fa9a1bc4e2607ecc0e51add363e1bc5ad42f7cc5baec7b253e8f685ad3"
  license "BSD-2-Clause"
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d585b8708b16c93ce9923a1ac8c1b8ce94e581c66966675b482da7464fee2ea"
    sha256 cellar: :any,                 arm64_sonoma:  "5492e570120f87b3e8729e200304be55c2af9c20163b0292f8db746ae132aee9"
    sha256 cellar: :any,                 arm64_ventura: "891def5dc77ba1e982ab1cb27efe8f47383988e7f503b91d844ceab49a3bac5a"
    sha256 cellar: :any,                 sonoma:        "e3d7ba37bcb616c8e01ec27539761d081b734a33ea109ae7cb40a0794c97e4da"
    sha256 cellar: :any,                 ventura:       "6c5a48f683db99c537f41f16056a48a645487e3f6c49742a68d9beafc8e7fb98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b20b6b0ec94438a5591f40fda416bbac8b05a078070227dcee776ee95a8cd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16cee2bf08b7c7a1ac67d23025f25c71ca5af8fa2a6627376eb6cecd4cb26323"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "mbedtls"

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
index 05d00b3..254d0ab 100755
--- a/meson.build
+++ b/meson.build
@@ -39,11 +39,6 @@ deps = []
 platform_files = []
 inc = []
 inc += include_directories('.', 'src', 'include/librist', 'include', 'contrib')
-if (host_machine.system() == 'darwin')
-	r = run_command('brew', '--prefix', check: true)
-	brewoutput = r.stdout().strip()
-	inc += include_directories(brewoutput + '/include')
-endif

 #builtin_lz4 = get_option('builtin_lz4')
 builtin_cjson = get_option('builtin_cjson')
