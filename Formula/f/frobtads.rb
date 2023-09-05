class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "https://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/v2.0/frobtads-2.0.tar.bz2"
  sha256 "893bd3fd77dfdc8bfe8a96e8d7bfac693da0e4278871f10fe7faa59cc239a090"

  bottle do
    sha256 arm64_ventura:  "dce25a4ec2c4448a2f9f201b00beb6c99c2abef5c50c63214df3d177e7028024"
    sha256 arm64_monterey: "0d58231276310d6f781bf35dcc430fa6495fe40222248cf6763f8042e92b87ec"
    sha256 arm64_big_sur:  "c73a8dc0cb339a9f039ccedd7950372a0c2fa136f11d59ac7d0f0cc03a2a1651"
    sha256 ventura:        "56d000455960c5ad32e0905ec5279ff0bfae157acfe419afc8b616a6e2fc51dc"
    sha256 monterey:       "4238e7e1b6e4bc87e4b23ad9e73f5b801a5aabc29301ab5cbaaa332176a47fdb"
    sha256 big_sur:        "b58665483ecdcaa4ebca91dc048884c6168dfc9d0265bd7bb62bc7a57f1814ed"
    sha256 catalina:       "9f7593c956b859ba6592f85e9741e04c2092e13ab4d689548bf5d4d92042501f"
    sha256 mojave:         "944c0aabe26e083c818100225920aa3c2d967bf07bf8a59d58455c92b99f61d6"
    sha256 x86_64_linux:   "1874c9c656d5e4a542300baca25b3d28f6e841f3fed9b123acbd958417874495"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match(/FrobTADS #{version}$/, shell_output("#{bin}/frob --version"))
  end
end
