class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "9d8b420b56a969ea3cf784861c72d26fa0e158fa1494d732df2c8a1480d36a5c"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24774d709beaff0de30d5f612d858661e9f627260028b14d9533ddd20d1cc660"
    sha256 cellar: :any,                 arm64_sequoia: "6d701db6458c6fcd8a921913df52386cd39610d9e51a6f9ddda0fd1599e57230"
    sha256 cellar: :any,                 arm64_sonoma:  "acba6b7422f04b5b5c040bd26d1429ae353d7b249a6b2960b47e7cda97664d45"
    sha256 cellar: :any,                 sonoma:        "608c3138fe1fa6184c6d300064fd1c85f23bc23afcb34c79ecc124056c8caea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86ded3a72136fb43d1457182e6e4ff36c878b82693c9e9a1e25df4f12e47a600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9ebd8a724f8d0c2510fc2aed894b2c69fb1b5838736e35dec94458b3c4f004"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"editorconfig", "--version"
  end
end
