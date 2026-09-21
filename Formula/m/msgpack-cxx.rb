class MsgpackCxx < Formula
  desc "MessagePack implementation for C++ / msgpack.org[C++]"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-9.0.0/msgpack-cxx-9.0.0.tar.gz"
  sha256 "303d3a7321aee65eb9450db8a6c973954e00af34b88ba0c0aca236bc50bfb8a9"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "cpp_master"

  livecheck do
    url :stable
    regex(/^cpp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01cb7589dc70746dda9933c2ca5b02197b948771544bdb519b8c5f626fd72f7e"
  end

  depends_on "cmake" => :build
  depends_on "boost" => :no_linkage

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Reference: https://github.com/msgpack/msgpack-c/blob/cpp_master/QUICKSTART-CPP.md
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++14", "-o", "test", "test.cpp", "-I#{include}"
    assert_equal "[\"Hello\",\"MessagePack\"]\n", `./test`
  end
end
