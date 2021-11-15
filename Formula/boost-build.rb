class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.77.0.tar.gz"
  sha256 "17ad1addbc08d1cc6ef52f7140097915bc4904c28c7d6d733c4a1a20d40bbc1c"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb227d41528da0ad8b768ac8309fca2bccaf7cd0ccca5f88f065e483ef9058a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e73b2881104b13fef6c2c6a0fff30bd2bf41ff998936850a0d9cbc7cac5b86b1"
    sha256 cellar: :any_skip_relocation, monterey:       "b6464291fef11c710998a570f88eaba5ed1b66000336ef975b6be24c858a7795"
    sha256 cellar: :any_skip_relocation, big_sur:        "651353d33f97fa5183c9acde956f7cfd67e36f288a4a35afaf907838e69dca36"
    sha256 cellar: :any_skip_relocation, catalina:       "bc8909293558dd1d3c55a9d2d5cdfa155e63b3540da63a719a33fa872f371921"
    sha256 cellar: :any_skip_relocation, mojave:         "26da04379b8dd9506778273f12277eb00b257653c11502d8ff50d3218587cc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9119799f6a153292e094509fdce67cb553b83cb8f32db717324b7a529cf99939"
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
    pkgshare.install "boost-build.jam"
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
