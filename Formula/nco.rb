class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.7.tar.gz"
  sha256 "6ddb397e7de4a7876e7d84ea82d4ee716cfd60ad8ee50ef49716945c505cbc1d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f48120f508b526c1d65e1e49a1aac82b9f1bc475d35eb9674689e25446df57f"
    sha256 cellar: :any,                 arm64_big_sur:  "36bb42798bdc5522cce9eb0736e05350d6f5c1723d34d058275ab56194138c55"
    sha256 cellar: :any,                 monterey:       "d5592375add37d98bbb1eb9257a52044cea0aacd6619a34723a9a1882cbc7a04"
    sha256 cellar: :any,                 big_sur:        "1f9458115d4ba8666df67010b6699a25a7d99a273f7bb4448c1ad7b0daea0b3e"
    sha256 cellar: :any,                 catalina:       "5aabec029e698e23958d49210ff8efb12afc17e3cb0f5cc98615ad3317acce5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f9321bb803d27f93f8a97ad6bd95b6d48c2fa3b64d1c311467219dcbfa677ef"
  end

  head do
    url "https://github.com/nco/nco.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openjdk" => :build # needed for antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  uses_from_macos "flex" => :build

  resource "homebrew-example_nc" do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  resource "antlr2" do
    url "https://github.com/nco/antlr2.git",
     branch:   "master",
     revision: "4fb7744d244eee46a981930c6bd1fd43dafe3f20"

    # Fix upstreamed here: https://github.com/nco/antlr2/pull/1.
    patch :DATA
  end

  def install
    resource("antlr2").stage do
      system "./configure", "--prefix=#{buildpath}",
                            "--disable-debug",
                            "--disable-csharp"
      system "make"

      (buildpath/"libexec").install "antlr.jar"
      (buildpath/"include").install "lib/cpp/antlr"
      (buildpath/"lib").install "lib/cpp/src/libantlr.a"

      (buildpath/"bin/antlr").write <<~EOS
        #!/bin/sh
        exec "#{Formula["openjdk"].opt_bin}/java" -classpath "#{buildpath}/libexec/antlr.jar" antlr.Tool "$@"
      EOS

      chmod 0755, buildpath/"bin/antlr"
    end

    ENV.append "CPPFLAGS", "-I#{buildpath}/include"
    ENV.append "LDFLAGS", "-L#{buildpath}/lib"
    ENV.prepend_path "PATH", buildpath/"bin"
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end

__END__
--- a/lib/cpp/antlr/CharScanner.hpp     2006-11-01 22:37:17.000000000 +0100
+++ b/lib/cpp/antlr/CharScanner.hpp     2008-03-19 20:09:21.000000000 +0100
@@ -10,6 +10,8 @@

 #include <antlr/config.hpp>

+#include <cstdio>
+#include <cstring>
 #include <map>
