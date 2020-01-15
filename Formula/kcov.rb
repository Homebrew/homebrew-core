class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/v37.tar.gz"
  sha256 "a136e3dddf850a8b006509f49cc75383cd44662169e9fec996ec8cc616824dcc"
  revision 1
  head "https://github.com/SimonKagstrom/kcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5a315633b03a413537445adaa8d7792d8e371c61e14898624846c68710d6fd6" => :catalina
    sha256 "a229154a02e28f524e8c0e2d7af39dfa1a9f4b9f37717634f8179edb7bd327ff" => :mojave
    sha256 "53f0444710122b2bb9e15fabad7688a0c4fe1a7e336a23777c2dc124f4c3c81c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build

  def install
    mkdir "build" do
      system "cmake", "-DSPECIFY_RPATH=ON", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
