class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v12.1.0/qpdf-12.1.0.tar.gz"
  sha256 "991edd3f6158d86a8779481a02bd7d90d0ff1d52bea46abe8186295ae0bf09fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "517c88053e2633ea01668e6ce94f4572331970485e0183f3ed828f2ef4adb142"
    sha256 cellar: :any,                 arm64_sonoma:  "806390cde3209f2c1da50d0fd018c796f88af0b846db58262716886ecea0bc8b"
    sha256 cellar: :any,                 arm64_ventura: "3776f591b2c96fa00f9922ced6d440a24e929f305e5d98e5f6fd4e1498884566"
    sha256 cellar: :any,                 sonoma:        "52c23d027a908fcbb901c26df4d1ae00cc566fe4616fd0584ecee375ed4e3205"
    sha256 cellar: :any,                 ventura:       "ab6bbe87991fed3a05b3394c6c3ad58547f1181e0baae5f3b1990df4bbe98c95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa686467e445fc053cb5dbb9c056184f6f1a5870436be79b92df8b3d67238740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95e7f2a9279a8a98b6a24910f594dfd07ba05b7aac01479ad01e262986dc9540"
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
    system bin/"qpdf", "--version"
  end
end
