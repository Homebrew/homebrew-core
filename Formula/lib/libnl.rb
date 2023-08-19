class Libnl < Formula
  desc "Netlink Library Suite"
  homepage "https://github.com/thom311/libnl"
  url "https://github.com/thom311/libnl/releases/download/libnl3_7_0/libnl-3.7.0.tar.gz"
  sha256 "9fe43ccbeeea72c653bdcf8c93332583135cda46a79507bfd0a483bb57f65939"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 x86_64_linux: "f8763b4ead5dedac63ba5721a5c52981bf14e76ec89ffaafa7e65398f87d54e3"
  end

  depends_on "pkg-config" => :test
  depends_on :linux # Netlink sockets are only available in Linux.

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <netlink/netlink.h>
      #include <netlink/route/link.h>

      #include <linux/netlink.h>

      int main(int argc, char *argv[])
      {
        struct rtnl_link *link;
        struct nl_sock *sk;
        int err;

        sk = nl_socket_alloc();
        if ((err = nl_connect(sk, NETLINK_ROUTE)) < 0) {
          nl_perror(err, "Unable to connect socket");
          return err;
        }

        link = rtnl_link_alloc();
        rtnl_link_set_name(link, "my_bond");

        if ((err = rtnl_link_delete(sk, link)) < 0) {
          nl_perror(err, "Unable to delete link");
          return err;
        }

        rtnl_link_put(link);
        nl_close(sk);

        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs libnl-3.0 libnl-route-3.0").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match "Unable to delete link: Operation not permitted", shell_output("#{testpath}/test 2>&1", 228)

    assert_match "inet 127.0.0.1", shell_output("#{bin}/nl-route-list")
  end
end
