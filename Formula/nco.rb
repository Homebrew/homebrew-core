class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.1.2.tar.gz"
  sha256 "1b86303fc55b5a52b52923285a5e709de82cbc1630e68b64dce434b681e4100a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "def60a807821a27ff2b36d8c27870b9e8d99d842bd31fd739bea974fa5fceff1"
    sha256 cellar: :any,                 arm64_monterey: "17173e1b1d6c04c7530758dd3cd4f827c5cdf9de8a9c5134868058bcaa59c53c"
    sha256 cellar: :any,                 arm64_big_sur:  "f5c3af46994d514c287a598753ab28813dfcddf5591572579be95e4fa45db92c"
    sha256 cellar: :any,                 ventura:        "c8e2bcdf7e84decc312ed8ce3f4239f78273c76b29a260dbbd7b8280e777e8af"
    sha256 cellar: :any,                 monterey:       "6beba9358e9012297d469184dd3085163edc14fb1a182dad904c84962037abeb"
    sha256 cellar: :any,                 big_sur:        "beaca6189ea1783fbe4cdc48594210de7cdea2a661d093fd7c4411570886a72e"
    sha256 cellar: :any,                 catalina:       "f9232486f979bf1c82b07229b30d07e5c5fb995c8bf04f344f77da6ab680dbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58e37f5a8f24bb322219a5f0161ed4834d810f670607e76438cb5288c18989a4"
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
