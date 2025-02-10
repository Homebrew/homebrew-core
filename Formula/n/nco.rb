class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.3.2.tar.gz"
  sha256 "645179433e0f54e7e6fefa9fcc74c1866ad55dd69f0fccbc262c550fcc186385"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a574a0bc89064c2dd7deab62f89345bb4daa66b44542d9c57e6cd685761dd05"
    sha256 cellar: :any,                 arm64_sonoma:  "3d40c36eca8a9c7d62af0dcb71bea75853ccd4e39e40b9b52fb1f2eb33163aae"
    sha256 cellar: :any,                 arm64_ventura: "9a4b445ec682dface0628879a438ebba386e4317ce6f2e668c6f45c0dd2aa3bc"
    sha256 cellar: :any,                 sonoma:        "b5497609c3cd7b5d4d2a75c1be1b46f9da428cec1ef99bbe0b234e84c30f1061"
    sha256 cellar: :any,                 ventura:       "b577c88fa6a214118000e181761c61da233bf10a4d552240800531d690071070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e7630a379735f70e2760eb79d0bc75fdd21e8e90699309b4d9a2cf1b8dba471"
  end

  head do
    url "https://github.com/nco/nco.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openjdk" => :build # needed for antlr2
  depends_on "gettext"
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  uses_from_macos "flex" => :build

  resource "antlr2" do
    url "https://github.com/nco/antlr2/archive/refs/tags/antlr2-2.7.7-1.tar.gz"
    sha256 "d06e0ae7a0380c806321045d045ccacac92071f0f843aeef7bdf5841d330a989"
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

      (buildpath/"bin/antlr").write <<~SH
        #!/bin/sh
        exec "#{Formula["openjdk"].opt_bin}/java" -classpath "#{buildpath}/libexec/antlr.jar" antlr.Tool "$@"
      SH

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
    resource "homebrew-example_nc" do
      url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
      sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
    end

    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
