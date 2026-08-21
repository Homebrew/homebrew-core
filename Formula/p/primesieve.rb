class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.15.tar.gz"
  sha256 "acaafd94cc30dbeef4808e682d0cb096c05d25f74eda5bacecefd323f697833f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23d18af2344f14d14e7c9bafba8af6a55977ac4b16a7ac846cc67a6d71671789"
    sha256 cellar: :any, arm64_sequoia: "5d16f66e7470f126df199bd3325c998514886a7575325163dbbdba54d75d3f37"
    sha256 cellar: :any, arm64_sonoma:  "24d659a8e34beb319c9bbd2db00807d43665e2cbf47ee0a16957baf5ab452b35"
    sha256 cellar: :any, sonoma:        "c4756dcacfab9b94bf8a030f949526551414f66beb535ad8a8ebc74de25f20f1"
    sha256 cellar: :any, arm64_linux:   "9685d8a575973dd258652663c08bacb868f774bf38aef2a668a1d3f3f08f1211"
    sha256 cellar: :any, x86_64_linux:  "ef3e8148314898b8f8c06ee1d28467bc2bfd53449071c781a7f866d6db954ee9"
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
