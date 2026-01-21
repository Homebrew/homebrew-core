class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.3.6.tar.gz"
  sha256 "70d64f461a0d5262274495ee1a9d85735aa3115281fdf01df4f946a919f9f6ae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d15e2ce209eb6281782c41ac706b63aafc4a3cc29cdbf22516b59799967a277b"
    sha256 cellar: :any,                 arm64_sequoia: "352b8fd32b785da50571c2a9af7b338c2d8d6691957281cb5909d15ba04653e8"
    sha256 cellar: :any,                 arm64_sonoma:  "88de1d76a3a9060b161d24c80bc0f561a0697414fe8bb1d075364cc7de2fd6b0"
    sha256 cellar: :any,                 sonoma:        "2930c77c0a5e129368d949d13a9796f3a29e4136aa1c159ba3a2703b5b4a8cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7275ad31456ed3930361f0340f7e06e5962e22ff405ce6393864662bd0194431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f12cd6d5663148d7083697471a466796329af3a63ed32d678d712aa27bcfe33"
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
      url "https://archive.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
      sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
    end

    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
