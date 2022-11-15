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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcad64c30f166d2252b1c4e7f54dbc90343f2e89e7981ef44c6ca0775fae630e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee705b9b468e8fb0a0ee5de383d92c45d99f76922588af6b2aff47e587fee79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b01468ff38165cef62b85462180653af35d0c2582e83859c7fa35a2116f89f60"
    sha256 cellar: :any_skip_relocation, ventura:        "880e693b12ab4b872f1b54b89918193bb43028232a93743f23c838e3a2bf6ecd"
    sha256 cellar: :any_skip_relocation, monterey:       "1ba103ced650911393ab68afedc3aa33c77f9fe1b9518c34a2b0dd6c00ffae26"
    sha256 cellar: :any_skip_relocation, big_sur:        "482592978d87a195871fe22dbad2be0a0a5ce9364b467b8953b2323af15c9c0d"
    sha256 cellar: :any_skip_relocation, catalina:       "7729a63edc79cbe0bbfd182ef9ffdd66b328785c48ad32be3b7b234ced401ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7088c63b513ac634e59792492e58e8a07455a0ffc0292fb70b87c0bafe7a488"
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
