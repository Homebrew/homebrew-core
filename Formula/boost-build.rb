class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.75.0.tar.gz"
  sha256 "889e931b25e435912e7b0dda89ae150fa1dabe419caccfbb923d41e85809e7df"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  livecheck do
    url :head
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c9efeef3c0749dbc9f7224ac82be198c52a1e620049ae63697fd0b8679f7258f" => :big_sur
    sha256 "1d59b5c0e5eb864a49b4990a9b23942554a45bbe86e27899aa657cb967420b06" => :arm64_big_sur
    sha256 "aa8ed675bc4dfed24661ed3dfaed3243da82da9e88026d6056d28f86fa8c489e" => :catalina
    sha256 "538c1f6cc8508eee4235ba0317a8d2b9bcdefd237093741821271394c16e1a3f" => :mojave
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  # Fix build system issues on Apple silicon. This change has aleady
  # been merged upstream, remove this patch once it lands in a release.
  patch do
    url "https://github.com/boostorg/build/commit/456be0b7ecca065fbccf380c2f51e0985e608ba0.patch?full_index=1"
    sha256 "e7a78145452fc145ea5d6e5f61e72df7dcab3a6eebb2cade6b4cfae815687f3a"
  end

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
    release = nil
    on_macos do
      release = "darwin-*"
    end
    on_linux do
      version = IO.popen("gcc -dumpversion").read.chomp
      release = "gcc-#{version}"
    end
    out = Dir["bin/#{release}/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
