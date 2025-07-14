class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.3.4.tar.gz"
  sha256 "265059157ab4e64e73b6aad96da1e09427ba8a03ed3e2348d0a5deb57cf76006"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02353f717e8ed2035866788430a1d0ba3a1d5b42116cf6e6e1dfae9aa3f2d684"
    sha256 cellar: :any,                 arm64_sonoma:  "d6be5813bad218baf0b2ede0da1841afd8e2274564a91e069c54b243a3461671"
    sha256 cellar: :any,                 arm64_ventura: "3cc3c1d2ee8d9c1995669a7e06415240bfc4a4845de33adca2c56599866279f2"
    sha256 cellar: :any,                 sonoma:        "194152055d5fc9b86143adfeebeecd55169f33b7f57b58af57824bf801dd9f47"
    sha256 cellar: :any,                 ventura:       "e4b5d0ac54363a9ca27c0431db1618890390f8b7fb4d4c5b043addb59b8af559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92805e74df3f254369b7fb60e6b35eece0fa5e89093bb0956909d0c632699efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c67b790ad4f58cd758283451f25bb05b85c2b54355967f849469c74ab8995c"
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
      args = ["--disable-csharp"]
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

      system "./configure", *args, *std_configure_args(prefix: buildpath)
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
