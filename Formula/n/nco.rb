class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.3.3.tar.gz"
  sha256 "f9185e115e246fe884dcae0804146b56df7257f53de7ba190fea66977ccd5a64"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "016683051edaab8c463bb06d0e67abb7f676e73bbc56da209b8117523fbcbe8c"
    sha256 cellar: :any,                 arm64_sonoma:  "06b88bf96fe1fcb98214c7fa0f18ac13f95f0dfb87354e9aaa470f25ddf19f88"
    sha256 cellar: :any,                 arm64_ventura: "0b9dfb56a0715a8493a38de209db30264ee3330c71a60c11a0e90e5b14feff5c"
    sha256 cellar: :any,                 sonoma:        "d36b2ab46f025cefe922332b0e79378fae84ac103b180c1ec2a6ce08c1740a5c"
    sha256 cellar: :any,                 ventura:       "6826e166a0f390722aa352f3f0d5a38af73d0d172eb67e95bd36eb0a481e82ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d68df0d8dc0af882b0ba189fdc6bf412935dc841f62d4d1ab97e0e82c1a93bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e18741d889ae6f8aef1edc838490626baf3c18c6b99e2ddac7b0ab3f0c598c6c"
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
      args = ["--disable-csharp"]
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

      system "./configure", *args, *std_configure_args(prefix: buildpath)
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
