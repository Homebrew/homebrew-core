class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.4.tar.gz"
  sha256 "44efa9151825487fa0562fa5c6d68837624059a8e2da9d15c83ceb4d498f7902"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2eeacf6f6ca687eeade92c237edc923b5f1ff7516216bc3b751ba7df4a4859f7"
    sha256 cellar: :any,                 arm64_ventura:  "ecc03da4235eec14eb4df50e4d019310a5135642929df31b7248e5d8f0fbd767"
    sha256 cellar: :any,                 arm64_monterey: "606a3c7f789bda80cab7c5c72006e7e70c839002c04afead860289f438d9ef3a"
    sha256 cellar: :any,                 sonoma:         "52a02706e7a6a1ffb53fbf747870722ad091cf787808f5247f4d4f97c13406d3"
    sha256 cellar: :any,                 ventura:        "033b7efa5b3f44df8f9a18bb0dd4b2d60b10749dddec3f53a5e1a8a392136963"
    sha256 cellar: :any,                 monterey:       "7432696a7338a2bc02c7bb535e074e61789a48b4f0ce37c65b246090400a85ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "561a4876522330782c0083c3108604bfc0f98f58bcfb58b256f2ffc14062c54a"
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
