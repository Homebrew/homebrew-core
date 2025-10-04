class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.3.5.tar.gz"
  sha256 "f2373b68279ff48b5cacf431f6a9f459bae75dc58d76f74cbff0834938aa6224"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7a7027eb6b1f10336f625e842dcf6e67b3b44c70bd0ec1ab1100943a14f510d"
    sha256 cellar: :any,                 arm64_sequoia: "990ced2127241ba5e013822466b3ac4ae555574eea95a162f545714ed5136d34"
    sha256 cellar: :any,                 arm64_sonoma:  "4bd2f8b04c8a3bccd095051a7cb5562f28bf2c309cd2b03358e411e6bca1dab4"
    sha256 cellar: :any,                 sonoma:        "fc75f6acafc3ab3b02aed373a276eeb1f6c490ea71aa145cffe2a415a080f6a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17c785b9fe80b0eb50c8b922099f99b8619b01af4123c90a41d618e64125fdca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdd61af2f8aa553149fd3d0e14a41b78491881e52497fa7a21137ce0b48f64a"
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
      url "https://archive.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
      sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
    end

    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
