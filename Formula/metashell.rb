class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/v3.0.0.tar.gz"
  sha256 "012f48508bbf0dbecf7775b4cca399512c5bbd1604d78f2016fe23a6352af90b"

  bottle do
    sha256 "0146ffe29dcd9274d6a77cb984f27e30809554e21c808e7c80dd7330e4ccce2c" => :sierra
    sha256 "8bac4ef92f0b661fb5d4edbc5447d870f5929186d794092f0c3cc0df822e3066" => :el_capitan
    sha256 "7d51a3a2c4a28b7956444fcecfd984dbba965630e2d0fcb60361313ed4d24dc5" => :yosemite
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
    (testpath/"test.hpp").write <<-EOS.undent
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    assert_match /const int/, shell_output("cat #{testpath}/test.hpp | #{bin}/metashell -H")
  end
end
