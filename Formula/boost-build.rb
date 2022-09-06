class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.80.0.tar.gz"
  sha256 "84f4f5842ba35652de9d75800bfca7f4aefc733c41386bfe5d10cb17868025e7"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ca44be738e443dafa397cf763ca7f05b2b6d5e832ae10447540fc7208ef3700"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b508672f793f912b13dae900c2122fc8ef09942188e6a76bd17063ce92b2bc37"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f766867e6a3434ad32640f0f2fbb312fb07e6b11e7de85cb94281ecc03e98f"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d4de71adf851c8937ab5414c0f9a26d61bd80ca2e04740d036b69bb30969e8"
    sha256 cellar: :any_skip_relocation, catalina:       "85a44497582ca1598516d3b4b728abb9a1b0e01abd4d9fdcd7c19f16c9e7a162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b407dae470f5b6228b6d21e663ede10ca72029d783eb1b3f00e3266d56b1eea"
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <iostream>
      int main (void) { std::cout << "Hello world"; }
    EOS
    (testpath/"Jamroot.jam").write("exe hello : hello.cpp ;")

    system bin/"b2", "release"

    compiler = File.basename(ENV.cc)
    out = Dir["bin/#{compiler}*/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
