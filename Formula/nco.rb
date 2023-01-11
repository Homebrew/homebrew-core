class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.1.4.tar.gz"
  sha256 "4b1ec67b795b985990620be7b7422ecae6da77f5ec93e4407b799f0220dffc88"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca5c997f3652ed0bc419e8d1722f6399a73fe63025d1b1cdec474ddcc3f1e814"
    sha256 cellar: :any,                 arm64_monterey: "ca1a244bee4ab1db0fb3621589f5d568094d0520359e67c66a94c8fd728f03bb"
    sha256 cellar: :any,                 arm64_big_sur:  "037f1bbd896b3c329f30342d1bdb7eb183a5c1e05aaac194cdd8f3548e4bd78a"
    sha256 cellar: :any,                 ventura:        "7559137ef86b987b1bd4df7b52a530c946ed969044c26b3915800c9f7fb7caca"
    sha256 cellar: :any,                 monterey:       "85d1126053f1c5c4d27180fc3672c377071752627749c20db25e5cba421ce479"
    sha256 cellar: :any,                 big_sur:        "51c34fd3bac53402bb72f0724d840e942e36efbbca27241d851cfc25882c6d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e9c6d599648a739fe7591ef3925645cea5c557a7da199e099f86032d6786e8"
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
