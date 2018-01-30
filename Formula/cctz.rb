class Cctz < Formula
  desc "C++ library for translating between absolute and civil times"
  homepage "https://github.com/google/cctz"
  url "https://github.com/google/cctz/archive/v2.1.tar.gz"
  sha256 "a86b9b2d339f5638a03a4bbcc1d8c632d2c429aecc44f5c548839c239c3b6e38"

  def install
    system "make", "install_hdrs", "PREFIX=#{prefix}"
    system "make", "install_lib", "PREFIX=#{prefix}"
    system "make", "install_shared_lib", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      // Copyright 2016 Google Inc. All Rights Reserved.
      //
      // Licensed under the Apache License, Version 2.0 (the "License");
      // you may not use this file except in compliance with the License.
      // You may obtain a copy of the License at
      //
      //   http://www.apache.org/licenses/LICENSE-2.0
      //
      //   Unless required by applicable law or agreed to in writing, software
      //   distributed under the License is distributed on an "AS IS" BASIS,
      //   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      //   See the License for the specific language governing permissions and
      //   limitations under the License.

      #include <ctime>
      #include <iostream>
      #include <string>

      std::string format(const std::string& fmt, const std::tm& tm) {
        char buf[100];
        std::strftime(buf, sizeof(buf), fmt.c_str(), &tm);
        return buf;
      }

      int main() {
        const std::time_t now = std::time(nullptr);

        std::tm tm_utc;
      #if defined(_WIN32) || defined(_WIN64)
        gmtime_s(&tm_utc, &now);
      #else
        gmtime_r(&now, &tm_utc);
      #endif
        std::cout << format("UTC: %Y-%m-%d %H:%M:%S\\n", tm_utc);

        std::tm tm_local;
      #if defined(_WIN32) || defined(_WIN64)
        localtime_s(&tm_local, &now);
      #else
        localtime_r(&now, &tm_local);
      #endif
        std::cout << format("Local: %Y-%m-%d %H:%M:%S\\n", tm_local);
      }
    EOS
    system ENV.cxx, "--std=c++11", "-I#{include}", "-L#{lib}", "-lcctz", "test.cc", "-o", "test"
    system "./test"
  end
end
