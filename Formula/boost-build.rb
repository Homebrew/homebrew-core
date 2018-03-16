class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.66.0.tar.gz"
  sha256 "f5ae37542edf1fba10356532d9a1e7615db370d717405557d6d01d2ff5903433"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff218f5b2fbfd2113fbd100716c09277ff03d56a78a3833fbbc1e8d503fe47a0" => :high_sierra
    sha256 "c630ecdbdfb4c903271744915f000f47bfa75f8cbe3c1d0699c2b599721f6fec" => :sierra
    sha256 "254744bad5670b902b2a63d04e76cfb355c5ea8e75d5084f833c5f1ca28271e0" => :el_capitan
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
