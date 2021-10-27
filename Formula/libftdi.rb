class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.5.tar.bz2"
  sha256 "7c7091e9c86196148bd41177b4590dccb1510bfe6cea5bf7407ff194482eb049"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url "https://www.intra2net.com/en/developer/libftdi/download.php"
    regex(/href=.*?libftdi1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "00a1cf52f2dd6bc539fe5dc2cd2aa539722b285e37c0969e5e9b0e98e14f35c5"
    sha256 cellar: :any,                 arm64_big_sur:  "998ea9ac5c02fdad06ad304dc36ccd0b010267271e7d68ff3f3cfbf407339067"
    sha256 cellar: :any,                 monterey:       "a51e714c8f9c12fabd316d643927d09458535aeff83e97a00cdbdeddedfc0962"
    sha256 cellar: :any,                 big_sur:        "26dfaad8173c39d9aa57354256ae4885ea4154a5c3f539c0cb8929e627cafd72"
    sha256 cellar: :any,                 catalina:       "8f20fb63150135151bac6d385c5c8fac07ccdc97c5d4a17d1d9aaf62737a606c"
    sha256 cellar: :any,                 mojave:         "52fd8c98d57a09972db3db70a405c32c17dc7ea60663c058b8cfa17d51fc1951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd40f6f49dc081c4cc7e3ea4b159b428d1e611dbc708c1d06bcb3c10f1f3fea"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "confuse"
  depends_on "libusb"

  # Patch to fix pkg-config flags issue. Homebrew/homebrew-core#71623
  # http://developer.intra2net.com/git/?p=libftdi;a=commit;h=cdb28383402d248dbc6062f4391b038375c52385
  patch do
    url "http://developer.intra2net.com/git/?p=libftdi;a=patch;h=cdb28383402d248dbc6062f4391b038375c52385;hp=5c2c58e03ea999534e8cb64906c8ae8b15536c30"
    sha256 "db4c3e558e0788db00dcec37929f7da2c4ad684791977445d8516cc3e134a3c4"
  end

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", "-DPYTHON_BINDINGS=OFF",
                            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                            "-DFTDIPP=ON",
                            *std_cmake_args
      system "make", "install"
      pkgshare.install "../examples"
      (pkgshare/"examples/bin").install Dir["examples/*"] \
                                        - Dir["examples/{CMake*,Makefile,*.cmake}"]
    end
  end

  test do
    system pkgshare/"examples/bin/find_all"
  end
end
