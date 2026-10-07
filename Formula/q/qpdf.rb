class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://github.com/qpdf/qpdf/releases/download/v12.4.2/qpdf-12.4.2.tar.gz"
  sha256 "8a58af5b6141319287c1883bec8bd1bd545b7567b7fc5e6ce5d25a1c85f36397"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "56e1db3fa21e577791180e1545bbcc5496bf13b3a3cc091a38f32fd5f14406c5"
    sha256 cellar: :any, arm64_tahoe:       "0e28e074080e9421ef3864938178110b648ad30597b290851abb005435704c9a"
    sha256 cellar: :any, arm64_sequoia:     "c53c9acf66108e0e2f91af257e4bf95a63b3bbf2ef457cbafde7ba26678e6770"
    sha256 cellar: :any, arm64_linux:       "13a73184b81c17b76fbdf514367fcfbe91b17943c84ef10de8e8d37222ff7524"
    sha256 cellar: :any, x86_64_linux:      "afefd57ebfb2ab05b5177d4aaba28c36fd6795e4919996a233e67f3fe5c461a7"
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
