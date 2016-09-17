class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/v3.0.0.tar.gz"
  sha256 "1ed0ffe4ecd0d2c376b002bea6b4188bc24e1be0eb363cadf2e9fbcbe7100b24"

  bottle do
    sha256 "e108fd2b8bd5c36a936b7fb1e84ad0c9296d400e615481ca1679b69e011948a6" => :sierra
    sha256 "fff1e495ddfda97b8826fa67333a1acf5847e6e6b0fcd4d8eb12332ea714e8f0" => :el_capitan
    sha256 "889f85d4601b30dd3b2eed8c64a3dbb0554600c0f624e6b8fbfff533922a9e79" => :yosemite
    sha256 "3f134dccf6bff48ab61cfdb312b03a3318591e6e41396f0b98795e9423f31421" => :mavericks
    sha256 "1c772d98ec272ed38167fa7cec02f91c4666616fbe189af8c9377cb8f28f579b" => :mountain_lion
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
