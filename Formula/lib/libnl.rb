class Libnl < Formula
  desc "Netlink Library Suite"
  homepage "https://github.com/thom311/libnl"
  url "https://github.com/thom311/libnl/releases/download/libnl3_12_0/libnl-3.12.0.tar.gz"
  sha256 "fc51ca7196f1a3f5fdf6ffd3864b50f4f9c02333be28be4eeca057e103c0dd18"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_linux:  "75c3dff2c1bd4a952ab0b661639b0629829b1d447e20cb6bb7471655d13ffe83"
    sha256 x86_64_linux: "1d3128ef9d8dde95c5da2f454abc2b4b62670fd72528f4a0b9f62e7e163561f7"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => [:build, :test]
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
