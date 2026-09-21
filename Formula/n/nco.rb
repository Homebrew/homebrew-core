class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.4.0.tar.gz"
  sha256 "c6e03cacbde7eae908eabfe65b2c1edc7b1754e07597b8f7fe2fc894f21b2dca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b69ff21ec0920494ad538809bcfa4a550e8d9ed87a5fbad1781898696f4ce9d"
    sha256 cellar: :any, arm64_tahoe:       "691c37e8d1159b11da8ad0dad9773bcf0e6bc5ff196a5dbc253810a7dc31aa67"
    sha256 cellar: :any, arm64_sequoia:     "97438892cc561ed6b78032d2de7cda7c4a4a622b5662b2491fd7d81ab4180dcf"
    sha256 cellar: :any, arm64_linux:       "b4efcb45db398f3cdcf8dbbbcfde1cba6a7c81adef7bc56c3535650a6be9bda9"
    sha256 cellar: :any, x86_64_linux:      "9cee5b1acd581f80a47c5560c239275a465b74707c74c449ad302d58256134b4"
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
        exec "#{formula_opt_bin("openjdk")}/java" -classpath "#{buildpath}/libexec/antlr.jar" antlr.Tool "$@"
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
