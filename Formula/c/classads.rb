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
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "ed590f0506873b6a0335e92654469e50424ca16a916afc92b9f5180906060bfc"
    sha256 cellar: :any,                 arm64_sequoia: "bf778bd185e235b5e755771e29b123cb64da53d8daeabf8b6950c205706b92e2"
    sha256 cellar: :any,                 arm64_sonoma:  "5302ef3e7141dcd4cd694d6321c782c8707a90ac36af8be04c137548dd36752e"
    sha256 cellar: :any,                 sonoma:        "f1e93502256b06a0fca5214a1df36c5f35b211b14d376f718d2a86088465dfe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f93a457d340d975d207f60f2b88049fab2ac1fc59f957421bb5e6d71a1817b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f04a28af4368948ee8ce693f3ab6e30d9d6294d726e2a04ad7ca44e84ffcf07"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Allow compilation on ARM, where finite() is not available.
  # Different fix upstream: https://github.com/htcondor/htcondor/commit/ae841558fcffa4cad12f019975292ad27b917f47
  patch :DATA

  def install
    args = ["--enable-namespace", "--without-pcre"]
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
