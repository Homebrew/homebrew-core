class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.3.1.tar.gz"
  sha256 "c527e991e1befcc839a14151a2982a20340ab1523ce98b66ef3efa2878ee039b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dfca19a3975250dc61032de062dea2ca7a5da369d0a7c03cd9d59667502e382"
    sha256 cellar: :any,                 arm64_sonoma:  "67e81f806077253d0b7992fea4482e91b009997c48338694b3aebc9afb2aaaa3"
    sha256 cellar: :any,                 arm64_ventura: "55f7f652c49ed89b4ea3461d60501cb6144a177e1281cf5a8c6997a74084eb48"
    sha256 cellar: :any,                 sonoma:        "9e5e82360754c2b5b252d575567b669cc35b75cdab6cf788e2aa5fd10b4bd1b7"
    sha256 cellar: :any,                 ventura:       "853f5543248a6e14a9e31ec6f79f7c4f258dc4d5b9a1cc40e8e50a6265c41aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e3534c769902dd7fe607df2864a8ae26648ef8761a911be05df8d85cbb8a38b"
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
