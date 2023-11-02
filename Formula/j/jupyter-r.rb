class JupyterR < Formula
  desc "R support for Jupyter"
  homepage "https://irkernel.github.io"
  url "https://github.com/IRkernel/IRkernel/archive/refs/tags/1.3.2.tar.gz", using: :nounzip
  sha256 "4ef2df1371e4b80dc1520da9186242998eb89eb0acfbc7d78de9aef4416bc358"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cecb8886fdd3bdc3237d81dda743764174759c38edf66053bd10655e2b85143"
    sha256 cellar: :any,                 arm64_ventura:  "d25370e5dac21ad0a1e5fcdb27a6ac7f2c6c6ada015bff27dc1ba1c60c4e3b09"
    sha256 cellar: :any,                 arm64_monterey: "46f061dc37d895b3dd531a37cdd012ce0b8b16f3c6b791240decb0c8b7b44227"
    sha256 cellar: :any,                 sonoma:         "623e3d3a25625e77886bed005ae3ec69a088c83faf2e84989e4689e73de8702a"
    sha256 cellar: :any,                 ventura:        "a799a0a63b33d667bb5960126d7e1e11933b4c9400a282dfb63b8e385a394af1"
    sha256 cellar: :any,                 monterey:       "3cb1b15d436d2a48c63fe02894f7f7d024adabd76dda850f39c7a9b55d88b565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80aa1d5d5d0ae740cbd6386e52585032be10b84373cd45558f396e38d7997409"
  end

  depends_on "pkg-config" => :build
  depends_on "jupyterlab"
  depends_on "r"
  depends_on "zeromq"

  uses_from_macos "expect" => :test

  resource "rlang" do
    url "https://cloud.r-project.org/src/contrib/rlang_1.1.1.tar.gz"
    sha256 "5e5ec9a7796977216c39d94b1e342e08f0681746657067ba30de11b8fa8ada99"
  end

  resource "fastmap" do
    url "https://cloud.r-project.org/src/contrib/fastmap_1.1.1.tar.gz"
    sha256 "3623809dd016ae8abd235200ba7834effc4b916915a059deb76044137c5c7173"
  end

  resource "ellipsis" do
    url "https://cloud.r-project.org/src/contrib/ellipsis_0.3.2.tar.gz"
    sha256 "a90266e5eb59c7f419774d5c6d6bd5e09701a26c9218c5933c9bce6765aa1558"
  end

  resource "cli" do
    url "https://cloud.r-project.org/src/contrib/cli_3.6.1.tar.gz"
    sha256 "be3006cec7e67f9ae25e21b4658c4bec680038c2ef7467df5f14da3311a05e36"
  end

  resource "fansi" do
    url "https://cloud.r-project.org/src/contrib/fansi_1.0.5.tar.gz"
    sha256 "c616ce357fbfd43253c366da578549a38066459058c22fb99c82fc05992e23f6"
  end

  resource "glue" do
    url "https://cloud.r-project.org/src/contrib/glue_1.6.2.tar.gz"
    sha256 "9da518f12be584c90e75fe8e07f711ee3f6fc0d03d817f72c25dc0f66499fdbf"
  end

  resource "lifecycle" do
    url "https://cloud.r-project.org/src/contrib/lifecycle_1.0.3.tar.gz"
    sha256 "6459fdc3211585c0cdf120427579c12149b02161efe273a64b825c05e9aa69c2"
  end

  resource "utf8" do
    url "https://cloud.r-project.org/src/contrib/utf8_1.2.4.tar.gz"
    sha256 "418f824bbd9cd868d2d8a0d4345545c62151d321224cdffca8b1ffd98a167b7d"
  end

  resource "vctrs" do
    url "https://cloud.r-project.org/src/contrib/vctrs_0.6.4.tar.gz"
    sha256 "8a80192356e724d21bd89a0ce3e5835856fd5bb1651e7fc205c6fee58fd001c8"
  end

  resource "base64enc" do
    url "https://cloud.r-project.org/src/contrib/base64enc_0.1-3.tar.gz"
    sha256 "6d856d8a364bcdc499a0bf38bfd283b7c743d08f0b288174fba7dbf0a04b688d"
  end

  resource "digest" do
    url "https://cloud.r-project.org/src/contrib/digest_0.6.33.tar.gz"
    sha256 "be702c886b1639be7eda4ea25a4261b30ce418c580f79bd78ec8d6cb4d327819"
  end

  resource "htmltools" do
    url "https://cloud.r-project.org/src/contrib/htmltools_0.5.6.1.tar.gz"
    sha256 "09b84ef819d03ba818c7d54a99b5b8b029e91370fd72b3410b5048f0f644a04e"
  end

  resource "pillar" do
    url "https://cloud.r-project.org/src/contrib/pillar_1.9.0.tar.gz"
    sha256 "f23eb486c087f864c2b4072d5cba01d5bebf2f554118bcba6886d8dbceb87acc"
  end

  resource "jsonlite" do
    url "https://cloud.r-project.org/src/contrib/jsonlite_1.8.7.tar.gz"
    sha256 "7d42b7784b72d728698ea02b97818df51e2015ffa39fec2eaa2400771b0f601c"
  end

  resource "repr" do
    url "https://cloud.r-project.org/src/contrib/repr_1.1.6.tar.gz"
    sha256 "3d2e6c9b363c1ec4811688deff7fb22093cadc9e0a333930382093d93c16673f"
  end

  resource "evaluate" do
    url "https://cloud.r-project.org/src/contrib/evaluate_0.23.tar.gz"
    sha256 "c9cf9c37502b8fbfa78e4eb96b8c3d1789060e49505c86c07cb7476da804a45c"
  end

  resource "IRdisplay" do
    url "https://cloud.r-project.org/src/contrib/IRdisplay_1.1.tar.gz"
    sha256 "83eb030ff91f546cb647899f8aa3f5dc9fe163a89a981696447ea49cc98e8d2b"
  end

  resource "pbdZMQ" do
    url "https://cloud.r-project.org/src/contrib/pbdZMQ_0.3-10.tar.gz"
    sha256 "39a20058e4027fab6f4a4cf0f557fef4e77409c9656d00252ef31cb6d90ad191"

    # Remove use of -flat_namespace.
    patch :DATA
  end

  resource "crayon" do
    url "https://cloud.r-project.org/src/contrib/crayon_1.5.2.tar.gz"
    sha256 "70a9a505b5b3c0ee6682ad8b965e28b7e24d9f942160d0a2bad18eec22b45a7a"
  end

  resource "uuid" do
    url "https://cloud.r-project.org/src/contrib/uuid_1.1-1.tar.gz"
    sha256 "1611240eb706e6f53400b25c9cf792ad90f151b72ed0918a1e756997f7abb716"
  end

  def install
    rscript = Formula["r"].opt_bin/"Rscript"
    site_library = lib/"R/site-library"
    site_library.mkpath

    resources.each do |r|
      if r.patches.empty?
        # no need to decompress the resource at all
        system rscript, "-e",
          "install.packages(pkgs='#{r.cached_download}', lib='#{site_library}', type='source', repos=NULL)"
      else
        # staging automatically applies the patch
        r.stage do
          system rscript, "-e",
            "install.packages(pkgs='.', lib='#{site_library}', type='source', repos=NULL)"
        end
      end
    end

    system rscript, "-e",
      "install.packages(pkgs='#{buildpath}/IRkernel-#{version}.tar.gz', lib='#{site_library}', type='source', repos=NULL)"

    inreplace "#{site_library}/pbdZMQ/etc/Makeconf",
      /PKG_CONFIG = .+/, "PKG_CONFIG = #{HOMEBREW_PREFIX}/bin/pkg-config"

    ENV["R_LIBS"] = site_library
    system rscript, "-e", "library(IRkernel); IRkernel::installspec(user=FALSE, prefix='#{prefix}')"
  end

  test do
    r_version = Formula["r"].version
    jupyter = Formula["jupyterlab"].opt_bin/"jupyter"

    ENV["JUPYTER_PATH"] = share/"jupyter"
    ENV["R_LIBS_SITE"] = lib/"R/site-library"
    assert_match " ir ", shell_output("#{jupyter} kernelspec list")

    (testpath/"console.exp").write <<~EOS
      spawn #{jupyter} console --kernel=ir
      expect -timeout 60 "In "
      send "print('Hello Homebrew')\r"
      expect -timeout 60 "In "
      send "exit\r"
    EOS
    output = shell_output("expect -f console.exp")
    assert_match "R version #{r_version}", output
    assert_match "Hello Homebrew", output
  end
end

__END__
--- a/src/zmqsrc/config/libtool.m4
+++ b/src/zmqsrc/config/libtool.m4
@@ -1045,16 +1045,11 @@ _LT_EOF
       _lt_dar_allow_undefined='${wl}-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
--- a/src/zmqsrc/configure
+++ b/src/zmqsrc/configure
@@ -10686,16 +10686,11 @@ $as_echo "$lt_cv_ld_force_load" >&6; }
       _lt_dar_allow_undefined='${wl}-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
-	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-	10.[012]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[012],*|,*powerpc*)
 	  _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
