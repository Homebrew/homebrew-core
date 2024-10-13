class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.4.tar.gz"
  sha256 "eb7081adebe8030e93b3675c74ac603438d10a36792246b274c79f11d8a987ce"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f7da8322e39600bdc9aca3a7cbeb25f9919bb83e3c8534ed0a979a8f022110a0"
    sha256 cellar: :any,                 arm64_sonoma:   "fa02e41a21f214425987866dad0ce74d252b5e3e7ad0f9b1f4d75ffe7dd1a1e8"
    sha256 cellar: :any,                 arm64_ventura:  "228d0bfe7758cd12500784ff76c44b9fa243fd1b86a8c747ad34d3188a9a36fb"
    sha256 cellar: :any,                 arm64_monterey: "9be7d308ad56ac5abdba3c3c730413167219b62f8158dfd0d52c061848279d24"
    sha256 cellar: :any,                 sonoma:         "8a41c7174b2d073959b6aebdd388a9522f96f2efaf358538c7fdeca6e9899858"
    sha256 cellar: :any,                 ventura:        "59e89c63d85b741b06b4892455fa9d26fd7ff32db4fa8e494b8073a5b7c35b8b"
    sha256 cellar: :any,                 monterey:       "f829ed656bf7d0e80741222928416aaaac7a6047cd30178d8f4a7d6bac88493f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc72e05d67e8afb3f01cda0808fadb937d5d607d4fc1e094c8b8f0724665bd28"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end
