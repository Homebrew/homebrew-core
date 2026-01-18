class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v12.3.0/qpdf-12.3.0.tar.gz"
  sha256 "5e59dbea264ce096bcaf230ea2a2fb1d991a9d56d940fd54c1a7570b48dde04b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0aea468ba83ad0a201aa2c2f353eafe8de5fdb1b8885cef4c59ba51216ff702f"
    sha256 cellar: :any,                 arm64_sequoia: "23a8b3e5b740fc89b944500b54b29dcfbc6ad35ecab2aecf4794acf115c6e840"
    sha256 cellar: :any,                 arm64_sonoma:  "2d918e2aad06ca1a750d3bedbc8b411f8883a7eabb391899f89f92ac917b1289"
    sha256 cellar: :any,                 sonoma:        "ef802aa680168e6f84aafb5d319a46c6f01205ae9cb800c6f9e9f7a8575cc78a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcdca7010dcb5da1a15ac11fa66e14804a6869efe3d22cc6541a8b7e8b286aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8044ee0d1bd315395428fcec6cefd2bf64417054c7eb8a239e001f057ef6b19d"
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
