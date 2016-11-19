class Googletest < Formula
  desc "Google's C++ test framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
  sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"

  depends_on "cmake" => :build

  def install
    args = [
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <gtest/gtest.h>

      int main()
      {
        EXPECT_TRUE(1 > 0);
      }
    EOS

    system ENV.cxx, "test.cc", "-lgtest", "-o", "test"
    system "./test"
  end
end
