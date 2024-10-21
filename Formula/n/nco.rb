class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.9.tar.gz"
  sha256 "6245886e2a18a4821b0fb768cf9906de09aeb47c303462c8e85f0d1a4f34956d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36fee2dba418873c6b8f70ce3910b72f6233d46c7d694e7a6bef71f99cc640e9"
    sha256 cellar: :any,                 arm64_sonoma:  "f8a925356271dd53ebba184d5eaf0d8d267842c03cdccfad97862285ff6487c3"
    sha256 cellar: :any,                 arm64_ventura: "d9f36db0f341909aac90ae55611edfd1f5dd5315e8674d1d43df8af981263576"
    sha256 cellar: :any,                 sonoma:        "433adbbea94d7eed23c146af84bb3e88b6026d131d4e2068f6d0cb941eb63f74"
    sha256 cellar: :any,                 ventura:       "6fdafffb41b987c8f1bfb74b3f0073e9acb12cd7f356f26c6af978e00ba5ef7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a60e8035abed7f02a875ab4b21cb55b2792c148a8462dce0b0cff94b8120c9d"
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
