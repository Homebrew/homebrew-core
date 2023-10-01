class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/5.1.8.tar.gz"
  sha256 "f22c63a3cbe1947fbf06160a6ed7b6d1934aa242fbe3feeb8d1964eef266b7d5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b218dc0d44d0092e608743cbb72d8ea31edc247e65cf0406c6abc7bcb1f5fc39"
    sha256 cellar: :any,                 arm64_monterey: "dc16d9013fdf30c97deb8a4c71b80be0da3a9f397b643b5e9eecec8595f770bd"
    sha256 cellar: :any,                 arm64_big_sur:  "a28ee76bc4aedc0593d48f049c2871df9633f8c3c695fdcab5587b5d14e61a28"
    sha256 cellar: :any,                 ventura:        "134167d5a432d8ea96e40dc527c61c10f5cfcec65fa2feec929047898b3d9883"
    sha256 cellar: :any,                 monterey:       "dc0c4201dffa9e8c403e3d065835d9368b875846a56f2b46998313807ad83f54"
    sha256 cellar: :any,                 big_sur:        "7efeb383400726df89f010aecc11613cad04a2b80ffa0207edd344c2fccb02db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af5fa88ca942456a711b9c9d5f45539fc6aa2b66570e41abba32af4b076879d3"
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
