class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.11/librist-v0.2.11.tar.gz"
  sha256 "84e413fa9a1bc4e2607ecc0e51add363e1bc5ad42f7cc5baec7b253e8f685ad3"
  license "BSD-2-Clause"
  revision 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3ec6f80dbc0c4a2f462a6e1485383684404cbc2cf0bef1e8893a847cf40cbc0"
    sha256 cellar: :any,                 arm64_sequoia: "bad9e900548801c915eb830471b6c77e87a9dc98b813625c81de70fbbed0432f"
    sha256 cellar: :any,                 arm64_sonoma:  "a7b306a05984387478ebd318c5eadd09303bec36d67cc9830d49d85a1b2e9938"
    sha256 cellar: :any,                 sonoma:        "de3c3d22ff646e823a60df6e77fee66031de804e73dc7580fc6ba89972acdf27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18175c43e2082dfff0edb5f4a0d9c3558d792995bf9985fb0bf4aa059cd0cc9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f293ec4fefab0d33b17e43019ad4593e764506d5fdb336d1884d829ba9fe531"
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
