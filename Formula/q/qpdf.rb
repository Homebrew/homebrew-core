class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.9.1/qpdf-11.9.1.tar.gz"
  sha256 "2ba4d248f9567a27c146b9772ef5dc93bd9622317978455ffe91b259340d13d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b01a2a7b9b940ef234c0832f0d1482c3ea5509049c969b46f39e446045609f20"
    sha256 cellar: :any,                 arm64_sonoma:   "a4aa3f1a65544861debcfbf6c5df9283e17e4a2f40b14b8c680fa9e8636c0ae9"
    sha256 cellar: :any,                 arm64_ventura:  "e9f29cb2c999847320165614618f92d9487172a6c5ca09a2691159b934072399"
    sha256 cellar: :any,                 arm64_monterey: "546a9271c1e4fa88c50a15ed0a6baf4a10e6729e249cdda7642337c125d309fc"
    sha256 cellar: :any,                 sonoma:         "0af29572086526cbd6e8ec28526d5b02fb97f0b3c7dca97bcf9de7d42a5f555d"
    sha256 cellar: :any,                 ventura:        "a7b542a3cbfeeaf64f7481d9cbc8a9edd2c4367783519281d59309578d50f8c1"
    sha256 cellar: :any,                 monterey:       "fe39e820c2a21942e07975bd1f1dc2b596219ffb3b90aa4053fe41223c08eeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f208edd304c812097562ceb2e069dc472d1b5a630086eedf4b645451f6a90384"
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
