class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.69.0.tar.gz"
  sha256 "493ec35e45ba5c0b8f839259672c375c182c13a9f94dacd2e2de85043b081ea4"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8893d6543e242093e89c1bd3a996b967f1a9e1acb3706cbda3dc30060a39b17a" => :mojave
    sha256 "76af4248e15c91e7c2d45eccdd8445023eff5fa6a089fee1363177a5661c26d1" => :high_sierra
    sha256 "9df12ef41a376876484511a0c1543424988952f18d45b25d81bf55eba1770f14" => :sierra
  end

  conflicts_with "b2-tools", :because => "both install `b2` binaries"

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
    out = Dir["bin/darwin-*/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
