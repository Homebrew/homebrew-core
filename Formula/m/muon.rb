class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.6.0.tar.gz"
  sha256 "5300e58c4b4d43e3026856004c79d746075aaa9d9e66d76ba9f32ce249495b81"
  license "GPL-3.0-only"
  revision 1
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9bce6352af4d970a3b54f28a21601f5348a15a564d5e7533c2ee1fcac824573a"
    sha256 cellar: :any, arm64_sequoia: "19129ebd38d6de26680e50a50aa89535456ac8b1b2fa45c99114849541292f2b"
    sha256 cellar: :any, arm64_sonoma:  "a6c7d5852da7a68dafb411b8c8e87e651151eb1bfbd35cefd4ce0a3750a0d13c"
    sha256 cellar: :any, sonoma:        "38d553b4ccd78ae8c5f46aef7a36f4262771b3e4a7642a57bdc72ca8402714e7"
    sha256               arm64_linux:   "40dce766e246b6c82ebd7980f023919acf99e33d84a55fde0c2fe1597f0e8570"
    sha256               x86_64_linux:  "ca66c70c23f9b9f31826d84de3bd608e7c6ee576695f9249b35ad3b33a189464"
  end

  depends_on "meson" => :build
  depends_on "scdoc" => :build
  depends_on "libarchive"
  depends_on "ninja"
  depends_on "pkgconf"

  uses_from_macos "curl"

  # Build against the libpkgconf 3.0.0 API (pkgconf_client_init args; tuple_find -> variable_eval_name)
  # https://lists.sr.ht/~lattis/muon/patches/70538
  # https://todo.sr.ht/~lattis/muon/145
  patch :DATA

  def install
    args = %w[
      -Dman-pages=enabled
      -Dmeson-docs=disabled
      -Dmeson-tests=disabled
      -Dlibarchive=enabled
      -Dlibcurl=enabled
      -Dlibpkgconf=enabled
      -Dsamurai=disabled
      -Dtracy=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"helloworld.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("hi");
        return 0;
      }
    C
    (testpath/"meson.build").write <<~MESON
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    MESON

    system bin/"muon", "setup", "build"
    assert_path_exists testpath/"build/build.ninja"

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end

__END__
diff --git a/src/external/pkgconfig_libpkgconf.c b/src/external/pkgconfig_libpkgconf.c
index ee4697fe..c58c3cdf 100644
--- a/src/external/pkgconfig_libpkgconf.c
+++ b/src/external/pkgconfig_libpkgconf.c
@@ -40,7 +40,11 @@ muon_pkgconf_init(struct workspace *wk, struct pkgconf_client *c, enum machine_k
 {
 	TracyCZoneAutoS;
 	c->personality = pkgconf_cross_personality_default();
-	pkgconf_client_init(&c->client, error_handler, NULL, c->personality);
+	pkgconf_client_init(&c->client, error_handler, NULL, c->personality
+#if defined(LIBPKGCONF_VERSION) && LIBPKGCONF_VERSION >= 20991
+		, NULL, NULL
+#endif
+	);

 	struct obj_array *pkg_config_path;
 	{
@@ -263,7 +267,11 @@ apply_variable(pkgconf_client_t *client, pkgconf_pkg_t *world, void *_ctx, int m
 	pkgconf_pkg_t *pkg = dep->match;

 	if (pkg != NULL) {
+#if defined(LIBPKGCONF_VERSION) && LIBPKGCONF_VERSION >= 20995
+		var = pkgconf_variable_eval_name(client, &pkg->vars, ctx->var);
+#else
 		var = pkgconf_tuple_find(client, &pkg->vars, ctx->var);
+#endif
 		if (var != NULL) {
 			*ctx->res = make_str(ctx->wk, var);
 			found = true;

