class Classads < Formula
  desc "Classified Advertisements (used by HTCondor Central Manager)"
  homepage "https://research.cs.wisc.edu/htcondor/classad/"
  url "https://ftp.cs.wisc.edu/condor/classad/c++/classads-1.0.10.tar.gz"
  sha256 "cde2fe23962abb6bc99d8fc5a5cbf88f87e449b63c6bca991d783afb4691efb3"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?classads[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "246c662700cc0ac2a7d9e7e5bf715215a00d01cf386d6ef285c071e090384efb"
    sha256 cellar: :any,                 arm64_sequoia:  "5ed81428780f7cec908f7100cf6acaa0e6dc048636e9b0154c50b45ac4373e13"
    sha256 cellar: :any,                 arm64_sonoma:   "661d3187c8f61482409ea38879746f2d43e6f2a910b8ea361b4e3507668383af"
    sha256 cellar: :any,                 arm64_ventura:  "0eab6257d1140e45a9de7be3672d4d78e62a639348cc30b00fab1f68048b5e84"
    sha256 cellar: :any,                 arm64_monterey: "7f4e50e3dc7c4c163e872815a050edb28feca33f5a56998023a187f11da1fcae"
    sha256 cellar: :any,                 arm64_big_sur:  "86c8c701a789392ad203154ec4dc6a7cd41401bdd0e667ce2c830c171f94bfd5"
    sha256 cellar: :any,                 sonoma:         "fa2d8e7c0713d7cdcf49ffe76d836058aa692553b6e6a970cda711696fa31680"
    sha256 cellar: :any,                 ventura:        "ea9ce2a0d341634d85367e39140f3e3aa7921e94830cdfe9c9f748acb35d857b"
    sha256 cellar: :any,                 monterey:       "3543be5b0a443e9600bab626a336244bdee95bf7a79856def626e740e6d0a0f8"
    sha256 cellar: :any,                 big_sur:        "738e16888e4030668b0bf2b7fe190b559b4c1d92dfcd09f95f190cef8deddcfb"
    sha256 cellar: :any,                 catalina:       "6217077882b497726e1b05407038fcff6ae512cabe8580f35731c5c3a3523538"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a5e99703af8185a5f39c39f6bf7f56707c17bab75d5a599c40294925d8f1d94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21874caebbec12fa4ee41c6f4830146dc725dfec2658b8c08eb02dc7d2585583"
  end

  # PCRE2 commit ref: https://github.com/htcondor/htcondor/commit/b7d84f79384dec9c500611afed87d71d77148176
  depends_on "pcre" # PCRE2 needs new release. Upstream fix in HTCondor requires new CMake build system.

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Allow compilation on ARM, where finite() is not available.
  # Different fix upstream: https://github.com/htcondor/htcondor/commit/ae841558fcffa4cad12f019975292ad27b917f47
  patch :DATA

  def install
    args = ["--enable-namespace"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    # Run autoreconf on macOS to rebuild configure script so that it doesn't try
    # to build with a flat namespace.
    system "autoreconf", "--force", "--verbose", "--install" if OS.mac?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end

__END__
diff -pur classads-1.0.10/util.cpp classads-1.0.10-new/util.cpp
--- classads-1.0.10/util.cpp	2011-04-09 01:36:36
+++ classads-1.0.10-new/util.cpp	2022-11-10 11:16:47
@@ -430,7 +430,7 @@ int classad_isinf(double x) 
 #endif
 int classad_isinf(double x) 
 { 
-    if (finite(x) || x != x) {
+    if (isfinite(x) || x != x) {
         return 0;
     } else if (x > 0) {
         return 1;
