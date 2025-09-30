class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.89.0.tar.gz"
  sha256 "8a154f61e8adfcaba21a54fdbfdeb5cda7fdef374ff1ad79be69644d9c2a97e2"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10da335480790cb39789466ea5a3bdd0dce3b0359e91438bd9bd52a2c636fa7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f75f1d6345e7a8baf6d53c8f6e4db2d8dbe4724cfa9598bd7b0c05dbf8d4b3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db0291a1760491d3200261e602785582bebf9687dd90ba3bbc5520e13f5ac98e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "777cf16f0dae799ee70b010775af19039180f9f4d5c2e2169aaa6bd19c42d2d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6816d550d826219ade18757195a78ff7636766def2e76a85de4e36347e56803b"
    sha256 cellar: :any_skip_relocation, ventura:       "01f05d1cc97c282b9c73eaee808b5816ba5238918d5a1a356bd242d69358cc5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94cdd3d42c76dbed25b99daebe2ed2b771aaafb81e86e03ea90ec43b478e9806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e581fb61742fc45c76ff67590d7ca781ab23085f92dfc6d4cc1ef8f1fee23c16"
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
