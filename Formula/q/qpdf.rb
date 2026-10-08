class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://github.com/qpdf/qpdf/releases/download/v12.4.2/qpdf-12.4.2.tar.gz"
  sha256 "8a58af5b6141319287c1883bec8bd1bd545b7567b7fc5e6ce5d25a1c85f36397"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a29f56ee4fbb9f342f0d257b2d8a719dfddda9b2fdc184d0ce5c6689a72d60e"
    sha256 cellar: :any, arm64_tahoe:       "266096bc99d1f3df03a686608bcdf98c4ca57e8b3dc0e7da4e4e97666956476a"
    sha256 cellar: :any, arm64_sequoia:     "801ac5a6b352e1cf25028490f0528af657f55bc6d0f805a912c8beac9eb41d7b"
    sha256 cellar: :any, arm64_linux:       "5b675fe704f52cea79fce57e49a65686b7c6df760c1bdbd252a5d60f333ce24a"
    sha256 cellar: :any, x86_64_linux:      "e4144b621208fb7ec500835f86be2a4f2087fec215928aef581f74a160e10b97"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qpdf", "--version"
  end
end
