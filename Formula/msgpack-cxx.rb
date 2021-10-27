class MsgpackCxx < Formula
  desc "MessagePack implementation for C++ / msgpack.org[C++]"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-4.0.3/msgpack-cxx-4.0.3.tar.gz"
  sha256 "9b3c1803b9855b7b023d7f181f66ebb0d6941275ba41d692037e0aa27736443f"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "cpp_master"

  livecheck do
    url :stable
    regex(/^cpp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b5be40ab99cd1a3fcd9cdfee1225f5b35766627ffc45e14310f44e3a5482ea2"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Reference: https://github.com/msgpack/msgpack-c/blob/cpp_master/QUICKSTART-CPP.md
    (testpath/"test.cpp").write <<~EOS
      #include <msgpack.hpp>
      #include <vector>
      #include <string>
      #include <iostream>

      int main(void) {
        // serializes this object.
        std::vector<std::string> vec;
        vec.push_back("Hello");
        vec.push_back("MessagePack");

        // serialize it into simple buffer.
        msgpack::sbuffer sbuf;
        msgpack::pack(sbuf, vec);

        // deserialize it.
        msgpack::object_handle oh =
            msgpack::unpack(sbuf.data(), sbuf.size());

        // print the deserialized object.
        msgpack::object obj = oh.get();
        std::cout << obj << std::endl;  //=> ["Hello", "MessagePack"]

        // convert it into statically typed object.
        std::vector<std::string> rvec;
        obj.convert(rvec);
      }
    EOS

    system ENV.cxx, "-o", "test", "test.cpp", "-I#{include}"
    assert_equal "[\"Hello\",\"MessagePack\"]\n", `./test`
  end
end
