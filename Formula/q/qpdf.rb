class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.9.0/qpdf-11.9.0.tar.gz"
  sha256 "9f5d6335bb7292cc24a7194d281fc77be2bbf86873e8807b85aeccfbff66082f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "37b5a16af4cb8315d35a7a0f7983061e2f6fba7164db529b234494bd7990a08b"
    sha256 cellar: :any,                 arm64_ventura:  "ab3b8a2a19b93c998cd54487e0c6851da40cd10bd0d0839a7cfa8355f7a2a6f9"
    sha256 cellar: :any,                 arm64_monterey: "321997f6eb9285bc9455d07aac0717d9880791d21fbca6bebdd3106ef97e2fb4"
    sha256 cellar: :any,                 sonoma:         "496530559b01e82aa325b6def8b6afdd009f82f63ba557dad5613b8e17c34540"
    sha256 cellar: :any,                 ventura:        "e5e4613f8343859da8b2293bd99c62f8829f3ddafdf836bc6bb2834e4e58ac0e"
    sha256 cellar: :any,                 monterey:       "1f24e13ca10c2abef832abc06ed5cd94dc91ec048563efd2452dff9292b7d9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "770f62a2916cc532db8136dd6c0d43c8b624b8031ff9b1da5a90d6e4ffb22800"
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
