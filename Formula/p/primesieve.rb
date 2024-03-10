class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.1.tar.gz"
  sha256 "64e7f5d3ce680262b865c7aec1381ffb13d13f75dd985b964ce33806e1bbf386"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d0a2bc5684a209029fd4cf0f597f351add96110a453b1db1c18773bfe6537f89"
    sha256 cellar: :any,                 arm64_ventura:  "9bab8dce016fc005cd2fe823b5ea772205da5158ef55e4123dc367f932b384f2"
    sha256 cellar: :any,                 arm64_monterey: "02c488e6d3bb6c746f35b61e0ffc9c5e5fed8ccc60c0dd491f3beb68bdd2c540"
    sha256 cellar: :any,                 sonoma:         "726329c7b1ff868bd35fe3c01ef593b8f29c790f4da30f2953beb9dfb8bbff8a"
    sha256 cellar: :any,                 ventura:        "a5ff1332a0362c7c649282a4f14f0f0b41e0428ef1a5c79d146fc81e25aae7b9"
    sha256 cellar: :any,                 monterey:       "ea94ba935bbc9cb9795062c48c8da7875398f5782c1077611eac8e197d49e514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5b6f4f46c560f873545f412daee09b5b829b9dcf9be3d869591fbb318c6ec8"
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
