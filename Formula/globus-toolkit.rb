class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "https://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "http://toolkit.globus.org/ftppub/gt6/installers/src/globus_toolkit-6.0.1477634051.tar.gz"
  sha256 "582fda929675f7e579dd7301d253cd27d4d2f2e91ec74f052a50af52ef2d161c"

  bottle do
    sha256 "919e6d3c7664dc0ba6745b3121aec2e9ca40c4097f526b6c026cdb916dcbedac" => :sierra
    sha256 "fc8f89ee1a07796f846360b5559b3515f2e6f8a9278c6a801176e324d3f2fae2" => :el_capitan
    sha256 "2bdfe7e4d4479ade4f764f6ad9373904a21df72fc8d9e18713d9442c39ecb704" => :yosemite
  end

  option "with-test", "Test the toolkit when installing"
  deprecated_option "with-check" => "with-test"

  depends_on "openssl"
  depends_on "libtool" => :run
  depends_on "pkg-config" => :build

  # Fix for "error: use of undeclared identifier 'VIS_CSTYLE'"
  patch :DATA if DevelopmentTools.clang_build_version >= 800

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    man.mkpath
    system "./configure", "--prefix=#{libexec}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
    bins = Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
    bin.write_exec_script bins
  end

  test do
    system "#{bin}/globusrun", "-help"
  end
end

__END__
diff --git a/gsi_openssh/source/openbsd-compat/vis.h b/gsi_openssh/source/openbsd-compat/vis.h
index d1286c9..4f55f9e 100644
--- a/gsi_openssh/source/openbsd-compat/vis.h
+++ b/gsi_openssh/source/openbsd-compat/vis.h
@@ -34,6 +34,7 @@

 /* OPENBSD ORIGINAL: include/vis.h */

+#include_next <vis.h>
 #include "includes.h"
 #if !defined(HAVE_STRNVIS) || defined(BROKEN_STRNVIS)
