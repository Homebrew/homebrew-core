class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.1.4.tar.gz"
  sha256 "4b1ec67b795b985990620be7b7422ecae6da77f5ec93e4407b799f0220dffc88"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "389883ef4fb37faff1ad6c4905020711657ae7343b9484d103b663fcca5244f1"
    sha256 cellar: :any,                 arm64_monterey: "42a2b6cd03ece6ee1cf465a90714c00c06c884fe641881a515a0f448f9eec513"
    sha256 cellar: :any,                 arm64_big_sur:  "1e7f040a59934b09dab40ecf9e8d5ef7570e77a912498eedb924cd173c0843b1"
    sha256 cellar: :any,                 ventura:        "6319d31b0d2b1ccf2af0aad08210be9f2d83ad8af2b80f055cc50e9d0875ad45"
    sha256 cellar: :any,                 monterey:       "b15593fbad57f6fb2088611b0011c37f054b29a88c024e66a30c491e488bb8fe"
    sha256 cellar: :any,                 big_sur:        "57361533668d2c0e1a3b1e1670ba3209d65314fe13892c0fd71af5d2e14e04ed"
    sha256 cellar: :any,                 catalina:       "2a7ca86db0c657c36b12038b23faf11d78becc31398229cf4daee4092893d8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f899da168ed45b8fb2c16ac27f6c97c72b991aa9028d67f83f9e3d41280c4c8"
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
