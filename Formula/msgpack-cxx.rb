class MsgpackCxx < Formula
  desc "MessagePack implementation for C++ / msgpack.org[C++]"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-5.0.0/msgpack-cxx-5.0.0.tar.gz"
  sha256 "80f997575acff12b1b64158ef9dbad4cff32595f985532e16c6ea67e317452d5"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "cpp_master"

  livecheck do
    url :stable
    regex(/^cpp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae4246359ff7b8141c09da79ad95272a1566319a267f315d46c2b570ab1c981d"
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
