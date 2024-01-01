class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.84.0.tar.gz"
  sha256 "1f252e3af95279ec569927a9a582db98f107635aefee773e03836d17c4e57b86"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5defd731acb09446aa5e432fcc81ad6dbcb23ab467d50c2b6f743f2920631be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac722d0713cbd9992246066df40ad8840ce8570b4311178c154f677fe0dd96a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41bc9ec192b428a89ff8e079e0d4757784c5da5263198305bc29e78c7f5dd8d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d14e73ece1ebb45d967dc82ff82dca21b84047c286ccc284586eaa9ab606d7d"
    sha256 cellar: :any_skip_relocation, ventura:        "26321442636f7c37ef13e1a5b64a915d4f69426579f18b8e33c86627c93a3377"
    sha256 cellar: :any_skip_relocation, monterey:       "90f0dfaefefa0287ca66ce6cad30435b13e48176db1c4a50deb217711973c4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd4236e74909f3d0129c0d6c1b4bbb1a1d37ee47ad7a732099c69bdf1a3d9a30"
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
