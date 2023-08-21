class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/5.1.7.tar.gz"
  sha256 "2b068558a605e30a465870166747e1d37726849814a5cfe41a000764b30e2ba1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcc21e88227b4eefe8d36ff7edcfd5225561176e15cd6ad3549e2b2587b31c1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3a65c0a5281ff0b4fdb6091727ebba3a143b4b72a8ddc5564c96038025f3f5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3ee43838dd2612b6abf53dd7ba38534f39005b4e5b3a5aba6cebcb093d53ed3"
    sha256 cellar: :any_skip_relocation, ventura:        "bc661af8d30264c2b3a1f9d49f9fad7480adcb934e412202c2c04c700786ffc3"
    sha256 cellar: :any_skip_relocation, monterey:       "95f0ec6e66e17f56612c3f18fb91db227b97660bd1b441a4b34820c0238ce1b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "efbfc6ce00dba2a57b19d51a07432297016350e05b07bf5e4c5dfc474081d108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6185f641b9586830ecea3dc3e6b8269083af9534657ee2258acec759ef6551da"
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
