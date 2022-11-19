class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.1.2.tar.gz"
  sha256 "1b86303fc55b5a52b52923285a5e709de82cbc1630e68b64dce434b681e4100a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f53dd4659b8d6f4c7f1546df2cf71dfc5c77a994587ff6789df05c4ab2a3544"
    sha256 cellar: :any,                 arm64_big_sur:  "08d662175e0bfb0eac16a6c234c7237a38255b7aa8987efc1f14fc75fb309edd"
    sha256 cellar: :any,                 monterey:       "96b32c1d1631287f72d5c8a74fd5fee0650337dbfebd4efa8479b619ee828e43"
    sha256 cellar: :any,                 big_sur:        "259ed2c189b2f808223fc3846d207f47fe5f9a3a3119a6b9596e021adaf82b02"
    sha256 cellar: :any,                 catalina:       "8169d493d10eadc9e81f755e97197ba83ea77f917d5e9ee03f14efa8905821a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d48b6da4cb732b174a46b854ecf123a001b41c8954543b96f470b2cff1a2d9ca"
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
