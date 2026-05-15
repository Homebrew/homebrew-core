class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.3.9.tar.gz"
  sha256 "705ffa98a78d468cdfaa5858f09213142265120fc26a78249a442ae2fa92ae96"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a791fa7cd3a6e10e8b755c9f1a719ba00f802bb2936f0fdd3acfbbd87b0cc167"
    sha256 cellar: :any,                 arm64_sequoia: "9922b62af9fa4424be9d671814a02b9577011b7b0935e5c7990585079e2c007f"
    sha256 cellar: :any,                 arm64_sonoma:  "4e66f6a6e7bf9f49a9ee6b744602d086dcaac400bd5844dae15eecce3ff6db2a"
    sha256 cellar: :any,                 sonoma:        "451eeb7cac009c052768d0736b3573bcc1f64c624b7a5413fb457fd6e93f6458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe26546af33e2c9cd0c41e86bda6e71c22f068cbdbf338bc635811a8f3a0e155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a4577d223524f092f864a4e79695627c05ee22d17e867826abf5418a435ac9"
  end

  head do
    url "https://github.com/nco/nco.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gettext" => :build
  depends_on "openjdk" => :build # needed for antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  uses_from_macos "flex" => :build

  on_macos do
    depends_on "gettext"
  end

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
