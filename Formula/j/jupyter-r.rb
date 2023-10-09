class JupyterR < Formula
  desc "R support for Jupyter"
  homepage "https://irkernel.github.io"
  url "https://github.com/IRkernel/IRkernel/archive/refs/tags/1.3.2.tar.gz", using: :nounzip
  sha256 "4ef2df1371e4b80dc1520da9186242998eb89eb0acfbc7d78de9aef4416bc358"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a87163b05cfc86db83fb1a1e78f379df9742d6a68c478ab8613e8d36c31564e"
    sha256 cellar: :any,                 arm64_monterey: "e22aa03630e2d3370ebf6da043265a33e272f7f3531bdcb6f3e5c909bcd71945"
    sha256 cellar: :any,                 ventura:        "b9bad93df13c5c3a8069c2a9444d893aa16b00bcda17cf69bf098325bfa754f1"
    sha256 cellar: :any,                 monterey:       "31a1f3e18b2bbd06f6ac60e392faf5859e528b091a8d0c4dea41bcd17c8ef2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ba5989e0c9ad5287b6a30c500e2b6ec36a5fb83408c68841740e6d94b81bc3"
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
    url "https://cloud.r-project.org/src/contrib/fansi_1.0.4.tar.gz"
    sha256 "3163214e6c40922bbb495229259ed8ce1bebd98b77098a6936d234e43da9c49f"
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
    url "https://cloud.r-project.org/src/contrib/utf8_1.2.3.tar.gz"
    sha256 "c0a88686591f4ad43b52917d0964e9df4c62d8858fe25135a1bf357dfcbd6347"
  end

  resource "vctrs" do
    url "https://cloud.r-project.org/src/contrib/vctrs_0.6.3.tar.gz"
    sha256 "93dc220dcde8b440586b2260460ef354e827a17dfec1ea6a9815585a10cfa5c2"
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
    url "https://cloud.r-project.org/src/contrib/htmltools_0.5.6.tar.gz"
    sha256 "15eb8e2745c3be5e9926aa773f21d551435e903aa1dd20712f8ab54055b5a067"
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
    url "https://cloud.r-project.org/src/contrib/evaluate_0.21.tar.gz"
    sha256 "3178c99cee8917d7d128806d064d4fecce7845ed07f42e759dcc0adda89c22b9"
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
