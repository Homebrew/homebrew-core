class Libnl < Formula
  desc "Netlink Library Suite"
  homepage "https://github.com/thom311/libnl"
  url "https://github.com/thom311/libnl/releases/download/libnl3_11_0/libnl-3.11.0.tar.gz"
  sha256 "2a56e1edefa3e68a7c00879496736fdbf62fc94ed3232c0baba127ecfa76874d"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_linux:  "cf02f2e5551dbb36e507e97a53c96710e6e7042232de601fe8f23bd92f0d3e65"
    sha256 x86_64_linux: "4f38d449757989f549668b55ff19e6d5a19d574c720bb15e3543b15564db966b"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :test
  depends_on :linux # Netlink sockets are only available in Linux.

  def install
    system "./configure", "--disable-silent-rules", "--sysconfdir=#{etc}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs libnl-3.0 libnl-route-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match "Unable to delete link: Operation not permitted", shell_output("./test 2>&1", 228)

    assert_match "inet 127.0.0.1", shell_output("#{bin}/nl-route-list")
  end
end
