class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.85.0.tar.gz"
  sha256 "508dd3ced744dce6a37ddc571743ccabec90bb9ebe8150fa8d46a9f7621111d7"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1f8a4d05e3f068295b409eb6d4a5a14aeaa176ff6317fd9bded34764959813a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5566b6c70cfe8e8cfc84cea49caa3d002d5f8ee1ad23e20a01192d853e5ac8ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf43b8c0c865cb7f8f05926e7a9d85a3f9aa9467315784c5c873defba083242"
    sha256 cellar: :any_skip_relocation, sonoma:         "22515cb9eda9d7c5ca411d54cdbccae0de62e6d6f3b3b0a3ac93f23ab13a09ea"
    sha256 cellar: :any_skip_relocation, ventura:        "d442db24d6b4d94cd438309039404875c68343114228a094d375e473ea09f5da"
    sha256 cellar: :any_skip_relocation, monterey:       "30235b0824740a2005eb2108b90205d1a576a56b1e2819185f4d22ac9db52984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d168ebf3c81d59906688df26378364aada7c672ba817018d3c43e06b063c96"
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
