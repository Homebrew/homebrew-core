class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.6.3/qpdf-11.6.3.tar.gz"
  sha256 "c394b1b0cff4cd9d13b0f5e16bdf3cf54da424dc434f9d40264b7fe67acd90bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a501b74f5e75b8c2de42a2c901879cade390e8e3d6aa01c4eb66709f6a63604"
    sha256 cellar: :any,                 arm64_ventura:  "f5af4faff6c412816af5cccdb86cb1cc8fcc1c514dbab1224325f88605b42be9"
    sha256 cellar: :any,                 arm64_monterey: "b3070fec0246b1c5644cdbf06a2609f698c16685b5ee44a00a79ed43b9f2e6a7"
    sha256 cellar: :any,                 sonoma:         "4e41fa6289316fca25d32ac470c8a73525e9d0c2f38962936fe7a79f37a9f0e4"
    sha256 cellar: :any,                 ventura:        "a20233689515691c0d26775dd1f722c173e00bf14108287f2961c9756c669358"
    sha256 cellar: :any,                 monterey:       "506f7c87c2a889b4be73afe4f1454d3b74db8640a8ab8fd8893826e48470f748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba0b3d078b0d2f4fa20b4b8db8325e60bed380be820cd19a98d4b27e782de95"
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
