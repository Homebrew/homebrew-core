class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.10/librist-v0.2.10.tar.gz"
  sha256 "797e486961cd09bc220c5f6561ca5a08e7747b313ec84029704d39cbd73c598c"
  license "BSD-2-Clause"
  revision 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a008dc6bced0ba4ac31a79da417afa539d4ab0d25b9d22769ea396a17b355c8c"
    sha256 cellar: :any,                 arm64_ventura:  "0033aff814342a0a4900ea6914411e7a9b506c938038017aa49f197c33283bd2"
    sha256 cellar: :any,                 arm64_monterey: "2604a28b6b7cec24badaf0ea472cae1b3524fcf1a082098394279867e5ad30ee"
    sha256 cellar: :any,                 sonoma:         "323c1b0e5a44a85657052208a0ed481a0a7aba20ab8e2d06c7e3fb5593c4cc4e"
    sha256 cellar: :any,                 ventura:        "cb36444b6c786bcfbbe40af9579f68a88e153e5d8192b8f55a8a8d6f0d5b4c4f"
    sha256 cellar: :any,                 monterey:       "c89029f1a47bae2ef37f7488942a86da57e2d49048f385df1442ee666f90a24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94498117f55c482ad621f50696c9592e8d7226ed92ef8d3028faf0afd3a69fc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "mbedtls"

  # Add build macos build patch
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
diff --git a/tools/srp_shared.c b/tools/srp_shared.c
index f782126..900db41 100644
--- a/tools/srp_shared.c
+++ b/tools/srp_shared.c
@@ -173,7 +173,11 @@ void user_verifier_lookup(char * username,
 	if (stat(srpfile, &buf) != 0)
 		return;

+#ifdef __APPLE__
+	*generation = ((uint64_t)buf.st_mtimespec.tv_sec << 32) | buf.st_mtimespec.tv_nsec;
+#else
 	*generation = ((uint64_t)buf.st_mtim.tv_sec << 32) | buf.st_mtim.tv_nsec;
+#endif
 #endif

 	if (!lookup_data || !hashversion)
