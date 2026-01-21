class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v12.3.1/qpdf-12.3.1.tar.gz"
  sha256 "6de2a390b807a881bba2ab1abb080e985c2338a64137807ed28a946a258ffc89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "743b373c6cbd172e788a28218de5bfe4802fd7bc266d7f7baa19eca35755526e"
    sha256 cellar: :any,                 arm64_sequoia: "c73184d33bd689074bda1b9d87e4855ffd93b9301ba17dc691210b2f3d9fdf2f"
    sha256 cellar: :any,                 arm64_sonoma:  "3ebc67d71199dd6a1e6c06aff7670b698af37aae5ab51e72a0d554a98d014508"
    sha256 cellar: :any,                 sonoma:        "1a9ee5b566d382e827e1a24d059b5d50fcea64ab6b8f2fd60ef7b6fdbf44a242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5dfb6e93e4501ebee0f1a753bbb8205aa776da8e4e500bcbbe1c7dfb58a65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9dd79762a64f55a1df360aef87e84e57779480c98dc2850b58a7d0d7492f355"
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
