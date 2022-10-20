class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.1.0.tar.gz"
  sha256 "6f0ba812e0684881a85ebf3385117761cffbba36ba842889cc96f111157f89c2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7b4b3ae88d8038b654f4d3ef816fa50840d19f52079a7f4074d05c8a43159de7"
    sha256 cellar: :any,                 arm64_big_sur:  "3962aaee46b68259b793f0b4b6764ce04969e1a6c2e857f8e31918b321d48b0c"
    sha256 cellar: :any,                 monterey:       "415c19c6d02e49c4b7186f2a8f863d045bb3c29eec4e004662b5fcf5a8bce98d"
    sha256 cellar: :any,                 big_sur:        "8bad0fa1cb198f7d712eba8c5157af563cb5f485c40083a2cb2904f4ef2cf8b2"
    sha256 cellar: :any,                 catalina:       "d6eab303d184739b9e0d92db0705da91d70615d2e45e56d45cd1a9254ec092a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18eb21562e02dcafa2786d883db895a89999737cf6459e485bd4d583685577b6"
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
