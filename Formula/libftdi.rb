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
    sha256 cellar: :any, arm64_big_sur: "a6e523e9065f328cc5218448b50cb56da7e4381bd345567174171481282decf7"
    sha256 cellar: :any, big_sur:       "8b406299142e6269c2c88d90d91e4ecae55b154768a7ce0e2d908e5cf7928466"
    sha256 cellar: :any, catalina:      "111c471640e58466f019255c65348cffaf691b61703a57aa64869663b1507670"
    sha256 cellar: :any, mojave:        "c4444db83840c4811f386aa7f37fd2747eec27c7d7beca4e76f490694a4ad377"
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
