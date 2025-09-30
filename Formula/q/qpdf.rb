class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v12.2.0/qpdf-12.2.0.tar.gz"
  sha256 "b3d1575b2218badc3549d6977524bb0f8c468c6528eebc8967bbe3078cf2cace"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab1f5d8c3971bf00c4d203782ca925f1bb7088d0a8f835f0fc64d76aeecbf8b7"
    sha256 cellar: :any,                 arm64_sequoia: "402fda223390d4fbe22d3c213a1b20a08e4472ecb9c88c3aedbd018071e5d533"
    sha256 cellar: :any,                 arm64_sonoma:  "f3225c6dc278a1a0284d44583ff89d46885b43fd7199f0713c7941e176c4d6e5"
    sha256 cellar: :any,                 arm64_ventura: "d19d7552a5e40c451d80f739dbbc8475d082701d98bb8d7e6b9d300393f8cadb"
    sha256 cellar: :any,                 sonoma:        "506b946cf917a12bf2d06a3066a92e6fb0cd9f3197f26aa9c162ee619f8b43ed"
    sha256 cellar: :any,                 ventura:       "8b6836b38b18e6f0475b9ea2d1e72808c10387f05e0f0bf7d5614b9d9b0a69ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a46169ba560636f07619b767ea0e31984b8b081c0b2a8a303f23ecb9ee9a7dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d32c18a220370eabbe62d4fc2a0e1d0c2c095183ae425ba5e940a023d4307f"
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
