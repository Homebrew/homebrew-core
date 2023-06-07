class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.1.6.tar.gz"
  sha256 "6b217156cb14f670c80d5de5c5b88905cdb281f6e239e83397f14eaf3d0b390b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5aaa45143f1ced743b6fc9ab3c8b0ddf777351a6a9f7b1816e533c0ea6d5d2e"
    sha256 cellar: :any,                 arm64_monterey: "f6a1cc7ab065b85c7d3e1a915c86cfb215086defe26f1ac065d83376a65cf613"
    sha256 cellar: :any,                 arm64_big_sur:  "1ad2cdf05262e05a702acf2e68d9cba717f9f3080a0ed07076b27561c168b2f4"
    sha256 cellar: :any,                 ventura:        "b7a024dd0675b8f3db08731c112622d954bca48ee4b0883abd2f483308a4f0f3"
    sha256 cellar: :any,                 monterey:       "798d67b694ec7f29a6f9ce22dbbc0fcab29dc6a1656ec86795f0712f0c39e90d"
    sha256 cellar: :any,                 big_sur:        "796662add2302a9c28a8f2b9c1b0021007c5311043f770e249451d334be9b398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfa2f40f4d44d2a7749d36d67ef5cf1ce40d35a4b4482d0312a7c613ff8b02f"
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

  resource "homebrew-example_nc" do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

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
