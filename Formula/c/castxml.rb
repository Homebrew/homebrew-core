class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/CastXML/CastXML/archive/v0.6.2.tar.gz"
  sha256 "9bb108de1b3348a257be5b08a9f8418f89fdcd4af2e6ee271d68b0203ac75d5e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1cde48e6a6e58e430f4ee46be252943cbcb2271e8577c4639be37eebdd536ee1"
    sha256 cellar: :any,                 arm64_ventura:  "d7ded2fba99df7ee395660728d91cf4187f05f0ea7805842e836ec3658d943b8"
    sha256 cellar: :any,                 arm64_monterey: "b02ec494a6b210797c71664482ad84e57dc69c68d142529cce99accc9dcea965"
    sha256 cellar: :any,                 arm64_big_sur:  "91117f5841beaa80b834f3f2c048d1ad5aa5733fe0f620f5ba496aa247802757"
    sha256 cellar: :any,                 sonoma:         "f01957aff6a3867431bdf453364dea79d452e3e583f9161812f92abefb1ae06d"
    sha256 cellar: :any,                 ventura:        "b8b1b0724b651d6786bd9da6bcf9e9bcee84636312c44c06314cc6d4fcc329e5"
    sha256 cellar: :any,                 monterey:       "9a8ab98a048c0ee688fc0fde68c6c98790b24eac17b89dd5d6b68faa6d962c8a"
    sha256 cellar: :any,                 big_sur:        "bf89e0b5774a3d8995bdf99a78f81955a261cfced7ef290fe7df037d6dec153d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f5fd8a102d9b21dc477b633308cb9911c5e212e1d3467d2ab0aa6935caf6adc"
  end

  depends_on "cmake" => :build
  depends_on "llvm@16"
  uses_from_macos "llvm" => :test # Our test uses `clang++`.

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
