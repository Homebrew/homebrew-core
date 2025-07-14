class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  url "https://github.com/synfig/synfig/releases/download/v1.5.3/ETL-1.5.3.tar.gz"
  sha256 "640f4d2cbcc1fb580028de8d23b530631c16e234018cefce33469170a41b06bf"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c63ed72c0400281f0b83a9db3437aa84426d37f482feaf4dcf2c9accc70caf6"
  end

  depends_on "pkgconf" => :build
  depends_on "glibmm@2.66"

  # upstream bug report, https://github.com/synfig/synfig/issues/3371
  patch :DATA

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <ETL/etl_profile.h>

      int main()
      {
        std::cout << "ETL Name: " << ETL_NAME << std::endl;
        std::cout << "ETL Version: " << ETL_VERSION << std::endl;
        return 0;
      }
    CPP
    flags = %W[
      -I#{include}/ETL
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    output = shell_output("./test")
    assert_match "ETL", output
    assert_match version.to_s, output
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
