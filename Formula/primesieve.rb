class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v11.1.tar.gz"
  sha256 "bab3bc4a1f3247f95b83dfc494ab0ce37a370a7b05379640f58e786d8d5fba61"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "120a1a269f8ed4ee6c164e257800a58b41dcf1beb0d642d6a7c9d750560f8f77"
    sha256 cellar: :any,                 arm64_monterey: "13d09364b1885785ea0a7fb7de379e4ccbd69e3cf68789a3d49839c8826674db"
    sha256 cellar: :any,                 arm64_big_sur:  "b3c8f23227b5e0870bdf4c3a49f795a860bc2a0067935b825f1cbaeef9168bec"
    sha256 cellar: :any,                 ventura:        "53fa5f14e9392a4e20b1f99db0f06c9b8cceff89837bab78f645cc19e1ef180f"
    sha256 cellar: :any,                 monterey:       "958153771aa5003990ccd7e7f8470f52da91aa891ef26857970f20459b94efb9"
    sha256 cellar: :any,                 big_sur:        "109da40994c495963033867984bae44a14d9897e121cc587e04edf6b28c54062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e286688ae56f8ad9a64058d6a7316fdc40f13adf713e7eb8a2397e907acf8e1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
