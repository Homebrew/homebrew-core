class Czmqpp < Formula
  desc "C++ wrapper for czmq"
  homepage "https://github.com/zeromq/czmqpp"
  url "https://github.com/zeromq/czmqpp.git", :tag => "v1.2.0", :revision => "a3c38eb6e3018887a8ecabc77f3029f7edb7b2d0"

  head "https://github.com/zeromq/czmqpp.git"

  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "czmq"

  needs :cxx11

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <string>
      #include <vector>

      #include <czmq++/czmqpp.hpp>

      using namespace std;

      int main()
      {
        const string addr = "inproc://hello-world";
        const string msg = "Hello, World!";

        czmqpp::context context;

        czmqpp::socket pull_sock(context, ZMQ_PULL);
        pull_sock.bind(addr);

        czmqpp::socket push_sock(context, ZMQ_PUSH);
        push_sock.connect(addr);

        czmqpp::message send_msg;
        const czmqpp::data_chunk send_data(msg.begin(), msg.end());
        send_msg.append(send_data);
        if (!send_msg.send(push_sock))
          return 1;

        czmqpp::message recv_msg;
        if (!recv_msg.receive(pull_sock))
          return 1;
        const czmqpp::data_chunk recv_data = recv_msg.parts()[0];
        string received_msg(recv_data.begin(), recv_data.end());
        cout << received_msg << flush;

        return 0;
      }
    EOS

    flags = ENV.cxxflags.to_s.split + %W[
      -std=c++11
      -I#{include}
      -L#{lib}
      -L#{Formula["czmq"].opt_lib}
      -lczmq++
      -lczmq
    ]
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    assert_equal "Hello, World!", shell_output("./test")
  end
end
