class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.5.0/qpdf-11.5.0.tar.gz"
  sha256 "15cb419e72c494a4a4b2e7c0eb9f4e980c8fd4e61ccdea64399e987f4c56c8ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ba1deadb1e278751a19290434edddf2ec28118866c4d371d9a1f96e4d93b462"
    sha256 cellar: :any,                 arm64_monterey: "73e28ad2ac7d2f64eedd216f3e0dc0c2822e702dbe2973ccb138913afdca0653"
    sha256 cellar: :any,                 arm64_big_sur:  "2ce384520c76417be1578dfee210d17862143683ac7f947df4909697e213f72f"
    sha256 cellar: :any,                 ventura:        "7d528ff4b2aadaa5b4ea2e63a636872562149a09c742a9216ea4fef67927692b"
    sha256 cellar: :any,                 monterey:       "499754b7bb43669d3a7d29d5ec77cc15ad787f39cc81c3ed7bfc08e356bc7eab"
    sha256 cellar: :any,                 big_sur:        "c8333739163e5433f38de54704845178c9af610e7abe457c823a1af23520b52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113bde267832ec78bbd98f4cbc9e1f4913f04bb761120416f677ceb834bf952c"
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
