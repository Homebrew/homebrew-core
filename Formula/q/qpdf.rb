class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.6.0/qpdf-11.6.0.tar.gz"
  sha256 "b137500168b49b26da8fe59d99bdd56562d7983b9db965a6a487515a2bf82607"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a1fd7e40e08f1f42871dfd07abca1e22c5d003fdb68b1e2b3c54cfc025bd0cd"
    sha256 cellar: :any,                 arm64_monterey: "5c319f0a4511aa2bd03f5021af303ad9be69b84bc94b49f737d5471d321d0a25"
    sha256 cellar: :any,                 arm64_big_sur:  "d36a27c3fa17e90e80a71d8cf3a51c6a993deda6a22b4e92f669d2fd88fecdac"
    sha256 cellar: :any,                 ventura:        "0e6436beb7bdf1315965861e0c990bfeea91b8c787eeb21dc33d31a0e0a8df17"
    sha256 cellar: :any,                 monterey:       "b300a0d0caa7f291ab506b11a541bf307b2ab6042fd30c074e46ecfb762ac0f2"
    sha256 cellar: :any,                 big_sur:        "e2e7c57b34e2e7846cccd45ace83f9a159f0bd62c24805300ef9812ec231bc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17389f869643e04ce02740bd21eb34583cdf4a398787a408b87819fd3f518963"
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
