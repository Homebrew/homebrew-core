class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://github.com/qpdf/qpdf/releases/download/v12.4.0/qpdf-12.4.0.tar.gz"
  sha256 "2783a032f443cc886dad41aa6d5fae3dabf23dec00ee7ec2cfb27ef67ebcf529"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3000f76fe98192cd4fbf8eedf659840dbe06d30a1ec4f6418c98618c1a24d984"
    sha256 cellar: :any, arm64_sequoia: "948c12ed80993ce51a2d3be875093aaf5c6d297c51dd4bdf984dd7517891e176"
    sha256 cellar: :any, arm64_sonoma:  "481535a50872fc4c02053a0e1f2dcd4b1d45139f869ae5b55ffcbb8b8bd11eb1"
    sha256 cellar: :any, sonoma:        "2c5583eff3e95ff1146cb7ec2647856c62b59d9ab1523a5fc8dda97445f21bd4"
    sha256 cellar: :any, arm64_linux:   "64cb9499e5406bc41e003a780aa1f56bb06c6098c286c7b3202cc4f5271c91d9"
    sha256 cellar: :any, x86_64_linux:  "ba5e4ea1115477bbac2e6a7a9b4517da891dbab34009b792a6d36a7dff7f87ca"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
