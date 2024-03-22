class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.net/"
  url "https://github.com/nco/nco/archive/refs/tags/5.2.2.tar.gz"
  sha256 "3908ce21dc7fd3be5f7fa4fe72bd96b69e6608bd246e6c1a504879ed6c7acfda"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb2e7f520c51b66d86b466229075b053fe881812c108011db6ce016e36489f72"
    sha256 cellar: :any,                 arm64_ventura:  "ada2d0e7e8dace9cc896931eb2a2751b15be60ec8c5e0b8e89eed190683fc197"
    sha256 cellar: :any,                 arm64_monterey: "0729f85916e324c1db9c95effa0c4f4942be0955aba13e28e1652a543f89ec38"
    sha256 cellar: :any,                 sonoma:         "e9207578c9c44ab98b5e4df4089faf0f4c680740ed680a1ee1e7ebf854c8ac4e"
    sha256 cellar: :any,                 ventura:        "be72fea6f620e04c330ab645976b2b9440ff072bd9b4aea14b55c55a7a2a3812"
    sha256 cellar: :any,                 monterey:       "75e4c0d3006c00862d67711785c896c4c8d52f6371830ed6a9f01e825f58b987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa083dda43031527523150c97f246148623148a1b4d112ef725827e1dc67c38b"
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
