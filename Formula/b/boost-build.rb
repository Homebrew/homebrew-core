class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.92.0.tar.gz"
  sha256 "bf2d9efb60cded0eca0c0be37e5c8a9fda7a3977a5c675b353aefced66ff3444"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aed344e5ed6b849e9d0bdecbe42feda27c6c90752ebdf8f14893932f15a2067"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e353ad980db044f229a0c6e41e4e06a83fb7fb6e0a42e29a34a3ca0237b4a8b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6aa8232f8cf7b0dca31aa11ec14a395d5a8562a3bc45b44f732b1bde8b0e83b"
    sha256 cellar: :any_skip_relocation, sonoma:        "973e1b848621fff7c5485172620fd275d8db0097ffee67f96d019f90c380fcd0"
    sha256 cellar: :any,                 arm64_linux:   "9d0c6352265769f19c508fa9eea9cf8cbe02f62c752cd1bc020ee89e3259f152"
    sha256 cellar: :any,                 x86_64_linux:  "c439aa502e36515675f58085efca7998249801195bd74819fdfdebe121631277"
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
