class Dragonbox < Formula
  desc "Reference implementation of Dragonbox in C++"
  homepage "https://github.com/jk-jeon/dragonbox"
  url "https://github.com/jk-jeon/dragonbox/archive/refs/tags/1.1.3.tar.gz"
  sha256 "09d63b05e9c594ec423778ab59b7a5aa1d76fdd71d25c7048b0258c4ec9c3384"
  license any_of: [
    "BSL-1.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]
  head "https://github.com/jk-jeon/dragonbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8d3d051a973de698e054f0cbd6635457ec76d3a290232b6637531587c06fc2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88e4534f61830511e3688998ce11edb471262826c3d201f38bf6e11115c3c44f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "529598b9212cd7ccc573f58334df5ef26f7925f3cdc41e319b7e3d3d562d6132"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d8da388b5e481bc6bb2cbb17686782e029d76ac71b3ac1d3ae9bab6f5669a4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4c36f3d7b48b0d949a443ac9527b638d12bc67e7f75e15eddfc267bc8fb3d8"
    sha256 cellar: :any_skip_relocation, ventura:       "129ef3cab84bf26377f8e8925123d655dd19f033f971ea2a8f01dc0d9ea06316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2a40a63f7e8ded666c88854f9f2ca6543db95ac304d965d5c4f87be3fa0d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3fe3c6c5efe142c195fc07706f632c654635a48b44d09dbda7a845db8add48"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(TestDragonbox)

      find_package(dragonbox REQUIRED)
      add_executable(test_dragonbox test.cpp)

      target_link_libraries(test_dragonbox PRIVATE dragonbox::dragonbox_to_chars)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <dragonbox/dragonbox_to_chars.h>
      #include <iostream>

      int main() {
        double number = 123.456;
        char buffer[25];
        jkj::dragonbox::to_chars(number, buffer);
        std::cout << buffer << std::endl;
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"

    assert_match "1.23456E2", shell_output("./build/test_dragonbox")
  end
end
