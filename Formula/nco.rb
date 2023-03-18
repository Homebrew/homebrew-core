class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.1.5.tar.gz"
  sha256 "6a35c2d45744b427a424896d32066e483c0a49a46dba83ba90f2cc5ed3dca869"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41f851d2f38983cc45403be77384f81dd138eb6874c99d0d5995c694863617c2"
    sha256 cellar: :any,                 arm64_monterey: "178c254b9773fd52c71fe8a60dbd9a14dbeaa140308a29dac5cd6308c4f5248a"
    sha256 cellar: :any,                 arm64_big_sur:  "8efac5dfd4ba324633b1db2f5e6ffaf5eb832847d16e8d44398c0e54e254758d"
    sha256 cellar: :any,                 ventura:        "8978b3996f27e78eec2afd8ab91bc31204697d4a5f76e0a227ea78d438f8945d"
    sha256 cellar: :any,                 monterey:       "08f6cdae70b2578ad68a756843fa52c5fff4e3305f841bd7dd0ee958c48c64e8"
    sha256 cellar: :any,                 big_sur:        "d6941e8003b6b81dfbd428ac778ab78031217557db0f6091b44d33def8e78d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d3217e2a6df6d09bc3f954b64e85da19cb0c544280bf9acb0fad305bc0bd4a"
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
