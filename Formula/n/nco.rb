class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.7.tar.gz"
  sha256 "fb463905b9c451cf9bd5a9c2259cdff054224cea3ef449145495cdeb966f06af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a84a3cc31c711924e4341ed51b152e03d04b7e28a2001ec53652657575e8c829"
    sha256 cellar: :any,                 arm64_ventura:  "36bfb1ca2e2e1f10309dd98581dcc1ac40747e8c2f66a2ea48ec8c3ddc720141"
    sha256 cellar: :any,                 arm64_monterey: "e457b14e7b6df698132ac80e363b41fa53d8421a6e8ffe016c5bb45e16dc711f"
    sha256 cellar: :any,                 sonoma:         "30bb32f7a2be3dbbda87b4d3df5aca14f3ee177983acd0d0e7fd7185e3d7d0cd"
    sha256 cellar: :any,                 ventura:        "277dcc522f2b5432b67a11416cdcf34b504ccf32170e0d963237359e8e7f7469"
    sha256 cellar: :any,                 monterey:       "0854f411d1f3c4cf7e126626694b0c727ec4fe729d62b2f3c8a0924cd63bb5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7c9ca183cc8e752f563774c83926202fa51f8883e098ce03b31936c9fbf15e7"
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
