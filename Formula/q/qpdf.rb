class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.7.0/qpdf-11.7.0.tar.gz"
  sha256 "f14a6ede3b7deb6bec1e327beeeb2e508e1a74aa7e62fbaa6f62d09c96627541"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f25f7ff7ccf3e53c2ddfff2140f632d0ea05b46341d963a5c665f1f7faaa0292"
    sha256 cellar: :any,                 arm64_ventura:  "feeabbf8dcea09c1b939ebdcf95e8e14cd0d640c763167aaded02fdbecf2f6df"
    sha256 cellar: :any,                 arm64_monterey: "6310e9258246955edecb1dc70beb6522bedde91f16695408bd4438c551ea0d4e"
    sha256 cellar: :any,                 sonoma:         "0840af5e3ce09cea3925d08a3e915cfe1ef6bae33f6fb4a66a3c13aff3accde7"
    sha256 cellar: :any,                 ventura:        "90e4c164d1075870a124ee87d2f9095681aad6273994811588844a0ffee7056a"
    sha256 cellar: :any,                 monterey:       "ba3412432111fac7dd3019fd9d79d5a4d5f95d27177494dc4d40e65608c2bd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4f844646930f924234f2c60f1b5490511a7b29798c02811b6a3a80ddb121639"
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
