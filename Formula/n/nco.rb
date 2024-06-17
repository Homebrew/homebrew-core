class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.4.tar.gz"
  sha256 "44efa9151825487fa0562fa5c6d68837624059a8e2da9d15c83ceb4d498f7902"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e06c92b4db3f900701d73db2035302598eeba44901c4be1f9ea7a2a0b3ac63b7"
    sha256 cellar: :any,                 arm64_ventura:  "40ea3caaff8445b187d43774c27e06b1d96ee84bee0cee80a6b93086fa8574f2"
    sha256 cellar: :any,                 arm64_monterey: "443e0a0e8ca196cdf7ac57347fa2dd8e6c8449be3fa5edeb5df2e4337e016127"
    sha256 cellar: :any,                 sonoma:         "4d1461f3002674cbcb7cc5761830b107c967d75a819325c4ae8a76413092d22e"
    sha256 cellar: :any,                 ventura:        "cbed6f43b1266cac1b2659e876ef6bfb29020ec6a2fe1fe460fc9e630846d4e0"
    sha256 cellar: :any,                 monterey:       "6998c0926a9aa2b89139c81a149ff120feac59a5547c0c46e7cfcdf6d36af153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb7d703fb59cf8f41a6f7dcb961ed9ce8a0f860bd3edea116e77b6b2bae9a70"
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
    resource "homebrew-example_nc" do
      url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
      sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
    end

    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
