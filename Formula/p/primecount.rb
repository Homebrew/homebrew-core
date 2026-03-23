class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v8.3.tar.gz"
  sha256 "4924f290a4fa408ed4506a6fda2c58d27ba8931dead74ce4923da0b9f6f157c3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "816850eb6513307203cb6ecbcb08f3c3b0ecb380cfff9dc9547e7655e4294ac9"
    sha256 cellar: :any,                 arm64_sequoia: "4c5731860f6e9a14eb2665f0a42a53b25223db5114eff0c130d5af5ec85277f6"
    sha256 cellar: :any,                 arm64_sonoma:  "71323991e2e7f2bf07acc77677afa9531d5ea2689602ed99f709ad2e4e3057ae"
    sha256 cellar: :any,                 sonoma:        "4388035702a89dcffe633d0840461078382faea326a11a59893623850397a2ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d7df42ed5041174d8166ca0d7fdfeaadeabaa1345a4f9ebf6417622ff3fd3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a19f271741f54b48b8b250357a2baa2f75bd9e88400f42d138abb42fd549d7"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end
