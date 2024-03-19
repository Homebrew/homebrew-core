class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.10/librist-v0.2.10.tar.gz"
  sha256 "797e486961cd09bc220c5f6561ca5a08e7747b313ec84029704d39cbd73c598c"
  license "BSD-2-Clause"
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a137368d63a4112828b2f8536e8ac419e5cc1fea7d829160366c0be7fee4d269"
    sha256 cellar: :any,                 arm64_ventura:  "0fbf53eef9ff1e01ef086ef822f50e76502371f60c1aef285dc9f044ef58e491"
    sha256 cellar: :any,                 arm64_monterey: "625d0cf67b82ec6e975ed740ba1d44b6545858b80518da9fc6949ff51cc063b2"
    sha256 cellar: :any,                 sonoma:         "7a14f013c77cc1e7ee5374d1f3356e2b0e667f2cbe23d62cb04cbd2355f62714"
    sha256 cellar: :any,                 ventura:        "210c5820e8ae2d4af924419051c03f1acbacb9ff1046cc0cf1be86547b22fc2e"
    sha256 cellar: :any,                 monterey:       "b209c7a34ec23eff152b023d9d8408c17452c8189f794556b994942538b6c337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "012694034be33f28319212b1bcc51a6f6eb55b9b64b742a6d577f10281acb8f8"
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
