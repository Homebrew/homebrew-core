class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.78.0.tar.gz"
  sha256 "78ba74587c8ba137d2f5f5ee1472e49d6291842ac944e2c24012c9e8a3d2f664"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "142474f896f7a560ee534c85c8a8eff41f9a4b42cd973155e4810b838876e3a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de245309a18531b9cc7a6e2b08645db3906afcab9e10dfac32794135943a0e03"
    sha256 cellar: :any_skip_relocation, monterey:       "054792cb57117e2fb2c68ee64e8dbcef7fd7a6f40e927569926b90ebf067ab8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9b7815f9ffdce7af7e8c6e960b59107180f8e1c382eec9fe910e99b2484a9e9"
    sha256 cellar: :any_skip_relocation, catalina:       "37fd5254f99dfb48577ace484d9be2f69dc67655119842fc32d34179cba41c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ed1bbc9683ecb2b9fd7b29cfaae6bc84cf699c7a487c18a293280865f2d271"
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
