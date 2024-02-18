class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.0.tar.gz"
  sha256 "f96d41accbdd6a6fcbace61472b381490dff060c5db0983262809eae8b2cc7a1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b81e25e563727b85887a3350d05155483c2c0f8f437a1ba3a6ccc379621bb28"
    sha256 cellar: :any,                 arm64_ventura:  "e02db6f08a99d328324e87e1d27c02b88cb74fbe46b44456ac599627204dbb64"
    sha256 cellar: :any,                 arm64_monterey: "3526108bc218a73b52b2b097ad8a9ba8db40628647849390a3fff0c22559ffe6"
    sha256 cellar: :any,                 sonoma:         "7f7ab8736013020c2563fe4e780c55fc75d8d9aea67ca0d19d6174500a2d2b67"
    sha256 cellar: :any,                 ventura:        "8daa6d309e6c3a82696fd100e8366df990c4019f72ab9bc4ad31e3e1d87f3f83"
    sha256 cellar: :any,                 monterey:       "509491116cb05b1db498f83bd855bee590f507f03213d6283cba24dee822db63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a3abca2b7533744b6e3be1a971eaba716949b0e2564f8f2cb5bc1697b8c1b98"
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
