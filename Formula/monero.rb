class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag      => "v0.14.0.2",
      :revision => "6cadbdcd2d952433db3c2422511ed4d13b2cc824"
  revision 2

  bottle do
    cellar :any
    sha256 "de277ac31cdc93c2b8d6f7f10b97b1ded645cee60d0eb224f08805499ca10e56" => :mojave
    sha256 "2ecdb5c2e2ec03b58bc551ce856e28664e59d206e1fadf7d7b9c28ad7b697fa8" => :high_sierra
    sha256 "b07a040b67617a7fd2b414dd0e1ccbfa219a61f89ff9bc73f712f2a6e7cef37b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libsodium"
  depends_on "openssl"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/archive/v4.3.0.tar.gz"
    sha256 "27d1f56406ba94ee779e639203218820975cf68174f92fbeae0f645df0fcada4"
  end

  # Upstream commit for Boost 1.70.0
  # https://github.com/monero-project/monero/pull/5328
  # reworked to apply on 0.14.0.2
  patch :DATA

  def install
    (buildpath/"cppzmq").install resource("cppzmq")
    system "cmake", ".", "-DZMQ_INCLUDE_PATH=#{buildpath}/cppzmq",
                         "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}",
                         *std_cmake_args
    system "make", "install"

    # Avoid conflicting with miniupnpc
    # Reported upstream 25 May 2018 https://github.com/monero-project/monero/issues/3862
    rm lib/"libminiupnpc.a"
    rm_rf include/"miniupnpc"
  end

  plist_options :manual => "monerod"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/monerod</string>
        <string>--non-interactive</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    cmd = "yes '' | #{bin}/monero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
      "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
      "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
      "ponies sixteen refer enhanced maul aztec bemused basin'" \
      "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end

__END__
diff -pur a/contrib/epee/include/net/abstract_tcp_server2.inl b/contrib/epee/include/net/abstract_tcp_server2.inl
--- a/contrib/epee/include/net/abstract_tcp_server2.inl	2019-03-07 14:25:34.000000000 +0100
+++ b/contrib/epee/include/net/abstract_tcp_server2.inl	2019-06-08 17:02:47.000000000 +0200
@@ -60,6 +60,12 @@
 #define DEFAULT_TIMEOUT_MS_REMOTE 300000 // 5 minutes
 #define TIMEOUT_EXTRA_MS_PER_BYTE 0.2

+#if BOOST_VERSION >= 107000
+#define GET_IO_SERVICE(s) ((boost::asio::io_context&)(s).get_executor().context())
+#else
+#define GET_IO_SERVICE(s) ((s).get_io_service())
+#endif
+
 PRAGMA_WARNING_PUSH
 namespace epee
 {
@@ -215,7 +221,7 @@ PRAGMA_WARNING_DISABLE_VS(4355)
   template<class t_protocol_handler>
   boost::asio::io_service& connection<t_protocol_handler>::get_io_service()
   {
-    return socket_.get_io_service();
+    return GET_IO_SERVICE(socket_);
   }
   //---------------------------------------------------------------------------------
   template<class t_protocol_handler>
@@ -383,7 +389,7 @@ PRAGMA_WARNING_DISABLE_VS(4355)
     if(!m_is_multithreaded)
     {
       //single thread model, we can wait in blocked call
-      size_t cnt = socket_.get_io_service().run_one();
+      size_t cnt = GET_IO_SERVICE(socket_).run_one();
       if(!cnt)//service is going to quit
         return false;
     }else
@@ -393,7 +399,7 @@ PRAGMA_WARNING_DISABLE_VS(4355)
       //if no handlers were called
       //TODO: Maybe we need to have have critical section + event + callback to upper protocol to
       //ask it inside(!) critical region if we still able to go in event wait...
-      size_t cnt = socket_.get_io_service().poll_one();
+      size_t cnt = GET_IO_SERVICE(socket_).poll_one();
       if(!cnt)
         misc_utils::sleep_no_w(0);
     }
