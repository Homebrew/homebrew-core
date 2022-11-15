class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/9.1.0.tar.gz"
  sha256 "5dea48d1fcddc3ec571ce2058e13910a0d4a6bab4cc09a809d8b1dd1c88ae6f2"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "366409825e592504a1a68e63c5c7415d1d90a08f4c4395bb856efb245b85cd3c"
    sha256 cellar: :any,                 arm64_monterey: "dfd44ffca7165995a6cdca2191e4e5bb6563385a71375fcd22a002e5e63d3133"
    sha256 cellar: :any,                 arm64_big_sur:  "20658415047bbd2856d1d4b5cd4886daeab829948a4f546e24bd176ba17d9e97"
    sha256 cellar: :any,                 ventura:        "34b2d0bfe62a0114aff46c0ae2a78e5d6e789ab7f55bc8035dbde7ac22a10a6a"
    sha256 cellar: :any,                 monterey:       "324344e5048ea4bf92352dcdfae63832d447c0d27cc01d45eecc6a2bebee6b5d"
    sha256 cellar: :any,                 big_sur:        "3616cabdb7e41f47275dac7bd60bc3496f375550eb0462f96edb5736c31d6c90"
    sha256 cellar: :any,                 catalina:       "d99a9571471d998a20f654f32499096037b4db5c33819d1c324cd29cea8f04bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "978a0685bf616cf383c4ffacf8210ad881f0f2d3ab94207005604648316dc32c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "make"
    lib.install "libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
