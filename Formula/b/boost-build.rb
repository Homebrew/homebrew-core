class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.88.0.beta1.tar.gz"
  sha256 "9afa8c761d5d9bcca5a7456720f06682ccd4702054e2106e246fe1d3ea2fefd2"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a92b4f6677f1ead6b81704da69661f073e6daac301d7aebf7d7fba4de3b82f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f71f2097e82437b2a63d11a24998c587fcb2c26d3ee0919400b7ebcbaaf24d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09bd99e989f72fae2dd9d9a4cd406e178671056d801ee8fa1a58f4d250c6eb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c6affb034c0ce4bce611dee59a3e9fe513b3361cb02fdf05c14595e6bc967c"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d4cf057b39d46c79284e45c2ffe7049c396571693bf24d76ba85244b3fd274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d832f6c60a12e5243522b5c0096882ef8092327d78dbb003c7fa91d38398771a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d37c59ecf713a4ab40c5cb44ff105bbaaab5cfbf463abf281d0c84b2c303d653"
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~CPP
      #include <iostream>
      int main (void) { std::cout << "Hello world"; }
    CPP
    (testpath/"Jamroot.jam").write <<~JAM
      exe hello : hello.cpp ;
      install install-bin : hello : <location>"#{testpath}" ;
    JAM

    system bin/"b2", "release"
    assert_path_exists testpath/"hello"
    assert_equal "Hello world", shell_output("./hello")
  end
end
