class Json11 < Formula
  desc "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url "https://github.com/dropbox/json11.git", :revision => "ec4e45219af1d7cde3d58b49ed762376fccf1ace"
  version "1.0.0"
  depends_on "cmake" => :build
  needs :cxx11

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json11.hpp>
      #include <iostream>

      int main() {
        Json my_json = Json::object {
          { "key1", "value1" },
          { "key2", false },
          { "key3", Json::array { 1, 2, 3 } },
        };
        std::cout << my_json.dump() << std::endl;
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-ljson11", "-o", "test"
    system "./test"
  end
end
