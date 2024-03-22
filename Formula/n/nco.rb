class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.2.tar.gz"
  sha256 "3908ce21dc7fd3be5f7fa4fe72bd96b69e6608bd246e6c1a504879ed6c7acfda"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3327be5509ffa7e34bd2d542f2b5d06a1cb1bc85d59dcc146d4074909ceef87f"
    sha256 cellar: :any,                 arm64_ventura:  "c1502290ca4933160a3d9890231dd483a5b0e02e2ec3c06c1a360cc81f4027fa"
    sha256 cellar: :any,                 arm64_monterey: "02c7ef6d288610535e9d8c82548c1fbe6cf4753f14198d34c9a560834829fcda"
    sha256 cellar: :any,                 sonoma:         "f55fce0a3d60524e358e6eabb0b7ae5c2603296ec114ca7aaf78cc243f2d5fc0"
    sha256 cellar: :any,                 ventura:        "42fea276f08276058b3f8d9a32dffe88904191255649770bb8237815517b419c"
    sha256 cellar: :any,                 monterey:       "3c5a7df747983b4d5615f3790ad69bebecfabb3d7469b20232c749846bbf2701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc33704e5858a0a452ec1556747c6add2f4744b1ce03a6b18f166c5b3cabd65"
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
