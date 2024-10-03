class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  url "https://github.com/synfig/synfig/releases/download/v1.5.3/ETL-1.5.3.tar.gz"
  sha256 "640f4d2cbcc1fb580028de8d23b530631c16e234018cefce33469170a41b06bf"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c052b60f8a2e21a109351218fa2d1402f6bf28c66e1695f3aba77a26dc959b2"
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"

  # upstream bug report, https://github.com/synfig/synfig/issues/3371
  patch :DATA

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ETL/misc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    EOS
    flags = %W[
      -I#{include}/ETL
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/config/install-sh b/config/install-sh
index e046efd..ec298b5 100755
--- a/config/install-sh
+++ b/config/install-sh
@@ -1,4 +1,4 @@
-#!/usr/bin/sh
+#!/bin/sh
 # install - install a program, script, or datafile

 scriptversion=2020-11-14.01; # UTC
