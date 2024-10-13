class JupyterR < Formula
  desc "R support for Jupyter"
  homepage "https://irkernel.github.io"
  url "https://github.com/IRkernel/IRkernel/archive/refs/tags/1.3.2.tar.gz", using: :nounzip
  sha256 "4ef2df1371e4b80dc1520da9186242998eb89eb0acfbc7d78de9aef4416bc358"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9e60d5223a4c0794c025996a7c56b33ffbed5618aa930246c32cf13726b98cb8"
    sha256 cellar: :any,                 arm64_sonoma:   "f5e53d2e1c07fada5048527bf93c183650f8f4b5ec3bb088d2f27136d06ce3c3"
    sha256 cellar: :any,                 arm64_ventura:  "6b747fb9bf5f4b4cc3d115143b213ed41cefeb8afb2254f0cb643a621f20f87e"
    sha256 cellar: :any,                 arm64_monterey: "8aa1108c74e5910e683727b8b4a793fa5c0108361f8dbf8f199f5c105957c531"
    sha256 cellar: :any,                 sonoma:         "0316f97858c3952691008a53a36107235976bc213a24c894d89de8890c8822eb"
    sha256 cellar: :any,                 ventura:        "7d99a0c04195211aaad73759ee745a55823854e0d326e34627220103fbf4d545"
    sha256 cellar: :any,                 monterey:       "a10453cf63c2b498366e1a90dd42d47b828502a870e527684558d1bef37e07ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b13b7b57330d27afc80e134f7d27c2b5207a9abc00a92f081d2fa21f834ede"
  end

  depends_on "pkg-config" => :build
  depends_on "jupyterlab"
  depends_on "r"
  depends_on "zeromq"

  uses_from_macos "expect" => :test

  on_macos do
    depends_on "gettext"
  end

  resource "rlang" do
    url "https://cloud.r-project.org/src/contrib/rlang_1.1.3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/rlang/rlang_1.1.3.tar.gz"
    sha256 "24a3424b5dc2c4bd3e5f7c0b54fbe1355028e329181b2d41f4464c8ade28bf0a"
  end

  resource "fastmap" do
    url "https://cloud.r-project.org/src/contrib/fastmap_1.2.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/fastmap/fastmap_1.2.0.tar.gz"
    sha256 "b1da04a2915d1d057f3c2525e295ef15016a64e6667eac83a14641bbd83b9246"
  end

  resource "ellipsis" do
    url "https://cloud.r-project.org/src/contrib/ellipsis_0.3.2.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/ellipsis/ellipsis_0.3.2.tar.gz"
    sha256 "a90266e5eb59c7f419774d5c6d6bd5e09701a26c9218c5933c9bce6765aa1558"
  end

  resource "cli" do
    url "https://cloud.r-project.org/src/contrib/cli_3.6.2.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/cli/cli_3.6.2.tar.gz"
    sha256 "4c0749e3711b2b6ae90fd992784303bc8d98039599cac1deb397239a7018e151"
  end

  resource "fansi" do
    url "https://cloud.r-project.org/src/contrib/fansi_1.0.6.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/fansi/fansi_1.0.6.tar.gz"
    sha256 "ea9dc690dfe50a7fad7c5eb863c157d70385512173574c56f4253b6dfe431863"
  end

  resource "glue" do
    url "https://cloud.r-project.org/src/contrib/glue_1.7.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/glue/glue_1.7.0.tar.gz"
    sha256 "1af51b51f52c1aeb3bfe9349f55896dd78b5542ffdd5654e432e4d646e4a86dc"
  end

  resource "lifecycle" do
    url "https://cloud.r-project.org/src/contrib/lifecycle_1.0.4.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/lifecycle/lifecycle_1.0.4.tar.gz"
    sha256 "ada4d3c7e84b0c93105e888647c5754219a8334f6e1f82d5afaf83d4855b91cc"
  end

  resource "utf8" do
    url "https://cloud.r-project.org/src/contrib/utf8_1.2.4.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/utf8/utf8_1.2.4.tar.gz"
    sha256 "418f824bbd9cd868d2d8a0d4345545c62151d321224cdffca8b1ffd98a167b7d"
  end

  resource "vctrs" do
    url "https://cloud.r-project.org/src/contrib/vctrs_0.6.5.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/vctrs/vctrs_0.6.5.tar.gz"
    sha256 "43167d2248fd699594044b5c8f1dbb7ed163f2d64761e08ba805b04e7ec8e402"
  end

  resource "base64enc" do
    url "https://cloud.r-project.org/src/contrib/base64enc_0.1-3.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/base64enc/base64enc_0.1-3.tar.gz"
    sha256 "6d856d8a364bcdc499a0bf38bfd283b7c743d08f0b288174fba7dbf0a04b688d"
  end

  resource "digest" do
    url "https://cloud.r-project.org/src/contrib/digest_0.6.35.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/digest/digest_0.6.35.tar.gz"
    sha256 "cc333fbb05059c4973d0ca5d0f1322c812943d81cdbfa18455f72267abd8781f"
  end

  resource "htmltools" do
    url "https://cloud.r-project.org/src/contrib/htmltools_0.5.8.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/htmltools/htmltools_0.5.8.1.tar.gz"
    sha256 "f9f62293ec06c353c4584db6ccedb06a2da12e485208bd26b856f17dd013f176"
  end

  resource "pillar" do
    url "https://cloud.r-project.org/src/contrib/pillar_1.9.0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/pillar/pillar_1.9.0.tar.gz"
    sha256 "f23eb486c087f864c2b4072d5cba01d5bebf2f554118bcba6886d8dbceb87acc"
  end

  resource "jsonlite" do
    url "https://cloud.r-project.org/src/contrib/jsonlite_1.8.8.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/jsonlite/jsonlite_1.8.8.tar.gz"
    sha256 "7de21316984c3ba3d7423d12f43d1c30c716007c5e39bf07e11885e0ceb0caa4"
  end

  resource "repr" do
    url "https://cloud.r-project.org/src/contrib/repr_1.1.7.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/repr/repr_1.1.7.tar.gz"
    sha256 "73bd696b4d4211096e0d1e382d5ce6591527d2ff400cc7ae8230f0235eed021b"
  end

  resource "evaluate" do
    url "https://cloud.r-project.org/src/contrib/evaluate_0.23.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/evaluate/evaluate_0.23.tar.gz"
    sha256 "c9cf9c37502b8fbfa78e4eb96b8c3d1789060e49505c86c07cb7476da804a45c"
  end

  resource "IRdisplay" do
    url "https://cloud.r-project.org/src/contrib/IRdisplay_1.1.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/IRdisplay/IRdisplay_1.1.tar.gz"
    sha256 "83eb030ff91f546cb647899f8aa3f5dc9fe163a89a981696447ea49cc98e8d2b"
  end

  resource "pbdZMQ" do
    url "https://cloud.r-project.org/src/contrib/pbdZMQ_0.3-11.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/pbdZMQ/pbdZMQ_0.3-11.tar.gz"
    sha256 "da7e204d857370201f75a05fbd808a2f409d440cc96855bb8f48f4a5dd75405b"

    # Remove use of -flat_namespace.
    patch :DATA
  end

  resource "crayon" do
    url "https://cloud.r-project.org/src/contrib/crayon_1.5.2.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/crayon/crayon_1.5.2.tar.gz"
    sha256 "70a9a505b5b3c0ee6682ad8b965e28b7e24d9f942160d0a2bad18eec22b45a7a"
  end

  resource "uuid" do
    url "https://cloud.r-project.org/src/contrib/uuid_1.2-0.tar.gz"
    mirror "https://cloud.r-project.org/src/contrib/Archive/uuid/uuid_1.2-0.tar.gz"
    sha256 "73710a14f812e34e891795b8945ea213f15ebcaf00b464b0e4b3fa09cf222afd"
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

    inreplace "#{site_library}/pbdZMQ/etc/Makeconf" do |s|
      s.gsub!(/PKG_CONFIG = .+/, "PKG_CONFIG = #{HOMEBREW_PREFIX}/bin/pkg-config")
      s.gsub! Formula["zeromq"].prefix.realpath, Formula["zeromq"].opt_prefix
    end

    ENV["R_LIBS"] = site_library
    system rscript, "-e", "library(IRkernel); IRkernel::installspec(user=FALSE, prefix='#{prefix}')"
    inreplace share/"jupyter/kernels/ir/kernel.json", Formula["r"].prefix.realpath, Formula["r"].opt_prefix
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
