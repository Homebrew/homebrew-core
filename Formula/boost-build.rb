class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.81.0.tar.gz"
  sha256 "cc905a6c35c68fa1258cbc149f574054a2063683efe69afb4190b05768424827"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3af7dde0f8a21e43509133aeaf0183824fa6c02bd82ca6177081dc56848f22f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2757cf8b76103e41b8e7c7b34bc31ff209f6feeaa821d636b05a3735b2f1cc95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96d54d0d154e8bccff90e2f3f85eecca9e8ce51138298cf3e0ff6dd8f32675dd"
    sha256 cellar: :any_skip_relocation, ventura:        "6530dde226225d9a66a677dbe9ab268863c3dfdc820eb712b8fd9aba218af67b"
    sha256 cellar: :any_skip_relocation, monterey:       "86282c5ed13d46d54eda2b097c2ecb0d5d976af4baf83afd72491cb20d9a4af9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a99263f39eeaf50ff4de7acfe51788a5f44b1b084a3e350f286e7491d346ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d47ffca39d87efdd9f1dc5086838d2e8c29e3602acd470e49f357e87948fb53"
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
