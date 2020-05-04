class Cppzmq < Formula
  desc "Header-only C++ binding for libzmq"
  homepage "https://www.zeromq.org"
  url "https://github.com/zeromq/cppzmq/archive/v4.6.0.tar.gz"
  sha256 "e9203391a0b913576153a2ad22a2dc1479b1ec325beb6c46a3237c669aef5a52"

  head "https://github.com/zeromq/cppzmq.git"

  depends_on "cmake" => :build

  depends_on "zeromq"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <zmq_addon.hpp>

      int main()
      {
          zmq::context_t ctx;
          zmq::socket_t sock1(ctx, zmq::socket_type::pair);
          zmq::socket_t sock2(ctx, zmq::socket_type::pair);
          sock1.bind("inproc://test");
          sock2.connect("inproc://test");

          std::array<zmq::const_buffer, 2> send_msgs = {
              zmq::str_buffer("foo"),
              zmq::str_buffer("bar!")
          };
          if (!zmq::send_multipart(sock1, send_msgs))
              return 1;

          std::vector<zmq::message_t> recv_msgs;
          const auto ret = zmq::recv_multipart(
              sock2, std::back_inserter(recv_msgs));
          if (!ret)
              return 1;
          std::cout << "Got " << *ret
                    << " messages" << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
