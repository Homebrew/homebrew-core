class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/v4.0.0.tar.gz"
  sha256 "02a88204fe36428cc6c74453059e8c399759d4306e8156d0920aefa4c07efc64"

  bottle do
    cellar :any_skip_relocation
    sha256 "4629398ca4b1bf5cf7779b8d5c9e6f066ea5e96f66063c265f0b13e106a0cba0" => :mojave
    sha256 "05387acf4adf651aaa011d02f5a08ddf49725a550440cc7eb496c1112166852b" => :high_sierra
    sha256 "14fc35b7b932170333d8260b8bda881844ffc68870aeb1a120ebd74072ef900c" => :sierra
    sha256 "209c4c475fa58cb42a2e98bd34c11a983463465ce4ee5470474177d6740fb2e5" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    # Build internal Clang
    mkdir "3rd/templight/build" do
      system "cmake", "../llvm", "-DLLVM_ENABLE_TERMINFO=OFF", *std_cmake_args
      system "make", "templight"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.hpp").write <<~EOS
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    output = shell_output("cat #{testpath}/test.hpp | #{bin}/metashell -H")
    assert_match "const int", output
  end
end
