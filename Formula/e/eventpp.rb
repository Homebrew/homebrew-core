class Eventpp < Formula
  desc "Event Dispatcher and callback list for C++"
  homepage "https://github.com/wqking/eventpp"
  url "https://github.com/wqking/eventpp/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "d87aba67223fd9aced2ba55eb82bd534007e43e1b919106a53fcd3070fa125ea"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c9e674ef83f8d4768c4bfd91497f725487973384179be6bd8986ab37c55d7b2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <eventpp/eventdispatcher.h>
      #include <iostream>

      int main() {
        eventpp::EventDispatcher<int, void (const std::string &, const bool)> dispatcher;
        dispatcher.appendListener(3, [](const std::string & s, const bool b) {
          std::cout << std::boolalpha << "Got event 3, s is " << s << " b is " << b << std::endl;
        });
        dispatcher.appendListener(5, [](std::string s, int b) {
          std::cout << std::boolalpha << "Got event 5, s is " << s << " b is " << b << std::endl;
        });
        dispatcher.appendListener(5, [](const std::string & s, const bool b) {
          std::cout << std::boolalpha << "Got another event 5, s is " << s << " b is " << b << std::endl;
        });
        dispatcher.dispatch(3, "Hello", true);
        dispatcher.dispatch(5, "World", false);
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test"
    assert_equal <<~EOS, shell_output("./test")
      Got event 3, s is Hello b is true
      Got event 5, s is World b is 0
      Got another event 5, s is World b is false
    EOS
  end
end
