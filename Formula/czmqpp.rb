class Czmqpp < Formula
  desc "C++ wrapper for czmq"
  homepage "https://github.com/zeromq/czmqpp"
  url "https://github.com/zeromq/czmqpp/archive/v1.2.0.tar.gz"
  sha256 "4ed983c3cfa7c5b0f035c2868357887f5663a7fce75c55da4b0dc47f37d83e2a"

  head "https://github.com/zeromq/czmqpp.git"

  bottle do
    cellar :any
    sha256 "8b6600a8b03189e2c9a143e3d5d411d27a7ab964a345146bfb92cec951828355" => :sierra
    sha256 "ea0e9813c30e58e8540dd87ed0eb8d462c63eda4b64cef7eab3ac871688fe078" => :el_capitan
    sha256 "cc0036c702e791542adf7477e9cf054f7eceeb2a1833dad81995babb312185ff" => :yosemite
    sha256 "107b5e49655e359d5bf3bfc68b24b422902cc13fb1fdb0939387135f2b7d4433" => :mavericks
  end

  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "czmq"

  needs :cxx11

  def install
    ENV.cxx11
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

    ENV.cxx11
    args = ENV.cxx.split + ENV.cxxflags.to_s.split + %W[
      -o test test.cpp
      -I#{include} -L#{lib} -lczmq++
      -L#{Formula["czmq"].opt_lib} -lczmq
    ]
    system *args
    assert_equal "Hello, World!", shell_output("./test")
  end
end
