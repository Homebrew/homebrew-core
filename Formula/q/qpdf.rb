class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://github.com/qpdf/qpdf/releases/download/v12.4.1/qpdf-12.4.1.tar.gz"
  sha256 "f045aa277be2356ff53a89a8622945958291177d2483afc20ede7c8a8cd3873c"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "69b7950f76b696fc06b416534ae4cdba2a98823002dae19884e4bd1f865a26f0"
    sha256 cellar: :any, arm64_tahoe:       "7e3e764df933760c100b2bd5d7177ebd0511733685e647e57d9e90afa01427c5"
    sha256 cellar: :any, arm64_sequoia:     "e7703cd4a9b12bc795b2ef2cb95b16c21a695ffd044ea3d698a34dba474ae872"
    sha256 cellar: :any, arm64_sonoma:      "a96ae2e150992a499f1eaf3cb00ae36c661cde22d3ae5de35a71d744f9d0ead8"
    sha256 cellar: :any, arm64_linux:       "de9946eedec7edde9d4668a61216294b0c2377747e87fab4c97fe6cec3608c9e"
    sha256 cellar: :any, x86_64_linux:      "e2f1bbcc782c60248f28f7925278977572c735a3ae82374f4692c59a10b4f6f1"
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
