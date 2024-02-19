class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.8.0/qpdf-11.8.0.tar.gz"
  sha256 "d9321f5fbc50251803630a5604ddc5ed9a4d93bc023d9a7436a302e7c9741259"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97a4012ac5336de174ab2596d670bef4d9865cb9c10606941818587f086b1733"
    sha256 cellar: :any,                 arm64_ventura:  "8a4a440bfbe3524f560761325660081361c9b07a5391f7e79f1a6edf1a70b339"
    sha256 cellar: :any,                 arm64_monterey: "bf664afc7066a537f7643c69b6280ebcdcefc5215a4d3ad037fa47b286f2eb40"
    sha256 cellar: :any,                 sonoma:         "2fe930ee8fd5aa26c51e61aef9804073ba87535fa8a28a685fd9d5975af5b2af"
    sha256 cellar: :any,                 ventura:        "399eac5b5a697ba198b8881f6ee953a11ec7c5777af72e07772fa54b4b9afd20"
    sha256 cellar: :any,                 monterey:       "9a9c2e322b6051db10f93b1149a59242e7a083e737c38e7cf1fa2c62b6f097aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a37746499ae9f0fe472dcd025e26c475fd46e32cec6a2a2cdd7322a729c4ca2"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
    system "#{bin}/qpdf", "--version"
  end
end
