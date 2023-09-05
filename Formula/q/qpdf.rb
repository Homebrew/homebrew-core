class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.6.1/qpdf-11.6.1.tar.gz"
  sha256 "8756633243c3bd7216f12fc2139736f32f18d37effe1d5b04f37340d8ed851b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6728cec2524193ab3e976e58981b390772fc7bf2c7165bf6a69f361f2fb703fb"
    sha256 cellar: :any,                 arm64_monterey: "db58b9e8bd284669dfd02e6938bbf30a9468fe345c4a5a230ed4a34fe390e448"
    sha256 cellar: :any,                 arm64_big_sur:  "7ae117ad5b891f23a6c632bdead1aea744c2d5dc6f5ee2cfb4ade97926397ea7"
    sha256 cellar: :any,                 ventura:        "84bc61c2a620aa6e844c2a40c13a40512fad3fb786d0d08fea696c73f359d02d"
    sha256 cellar: :any,                 monterey:       "8fe66e87afff15f2f36a4ea6e6b262264a4fb30d32f1479f90eae4efb3e84cad"
    sha256 cellar: :any,                 big_sur:        "9f686c105c73730f3d94b824298a73c4a31aabdae17e68d6ae1dd72da6598894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab89e20a348918e3eaa9813e48f912211b178d06faa29dcbf37ae992863d2fa3"
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
