class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.6.2/qpdf-11.6.2.tar.gz"
  sha256 "9d7011c348abb9ec281dfb0675abcc4a670a14ca4fafd8b945dac5817035acb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4ca8ce67f7e3c8b9861a3be6a7861ee92559b4f5d464eb849b062d330e0db44"
    sha256 cellar: :any,                 arm64_ventura:  "c47d45c9f1d749c7cbf641477c63d2a8c7fcb527f090beab71d17e29a5064d8c"
    sha256 cellar: :any,                 arm64_monterey: "3869c7f9763f7826c9125b5976496dd6b67adc201607f1cd3bbcca6c83669849"
    sha256 cellar: :any,                 sonoma:         "b78110a9e5f9a9a10081119ad1e09eb953ee899b3210a67636f6ae5bd7f7c72b"
    sha256 cellar: :any,                 ventura:        "18135ec596e3ddf2cd96754f646659ce4b55afbf1dd35245f1cb09cd4567e588"
    sha256 cellar: :any,                 monterey:       "abde148fe6da13ea6fd728f17e31ac79f2f7868f421069576096321ef2b48e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec42874882b81ac35c6d87565a099d04b268dd465601862cf5f697beb0e9dca"
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
