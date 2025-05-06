class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.88.0.tar.gz"
  sha256 "a131c25bfe7c1b1e20da89a4c6e90a58a4bc55b361ae8c10199bb68b280aab96"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad72a5f9a660259b97a0165a5df1e1a37a1cf5bc9c66ce453629711ab47df7db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecfcbe45e2a501634fe259f01668ba5f05f1910a8ff1e726cb752ffc725136b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea7e80e6680e5edddd3db83659379ffbed349b0e7792c1253449ce290558d80c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c2d51929b85f8d3800d040b160658fa6d822c552991e8acb8a968dbea818ce"
    sha256 cellar: :any_skip_relocation, ventura:       "3cd1353dbe93c2a68fa46a71512f0506565eb4fa8be74a0ef2c346effea128b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f1946985cf4ce1b85052efa4d8bf16295d20594e2ffdbf6caa6f6697b64e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff1ab4441869e2303895ec3d41be52978a335676fff986d1c581133cc3d0022"
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
