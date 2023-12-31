class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.3.3.tar.xz"
  sha256 "aab40aab2acd735c500f296bacaa5c84ff0488221a4068ce9946e973beacc5ae"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "83276dcdbbcaf6a7074479c4b0de74a4c6cd00888e1ff7903aba00277f1077f9"
    sha256 arm64_ventura:  "691c664e463a3beff6aa199b8cf91c1f88aa42bc2b7cc56729c203f24765382b"
    sha256 arm64_monterey: "3cea16604ef42a8666ceeccdab0df9f073121e073f761b82ca687cf41dd22a60"
    sha256 sonoma:         "fb174e06f20d643eeaa415f82126174a5c266d0fdb540d675638f35346265da8"
    sha256 ventura:        "4a14d8bd055651f93c5f7d352e0991bd7874e8492b45580f59eafc71ced5db15"
    sha256 monterey:       "51276762b8825e0dcb8a0ccfd2cd57f639e3e7cbc5ec4ee53f81647c1f6e8b30"
    sha256 x86_64_linux:   "9abe37d9d17c6f06687d1ffbbd5cd1aa652bc67aa602e021a0e500b1435d0fab"
  end

  head do
    url "https://gitlab.nic.cz/knot/knot-dns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "lmdb"
  depends_on "protobuf-c"
  depends_on "userspace-rcu"

  uses_from_macos "libedit"

  # build patch to use `IPV6_PKTINFO` on macOS
  # submitted issue and build patch via https://gitlab.nic.cz/knot/knot-dns/-/issues/909
  patch :DATA

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-module-dnstap",
                          "--enable-dnstap",
                          "--enable-quic"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf
    <<~EOS
      server:
        rundir: "#{var}/knot"
        listen: [ "0.0.0.0@53", "::@53" ]

      log:
        - target: "stderr"
          any: "info"

      control:
        listen: "knot.sock"

      template:
        - id: "default"
          storage: "#{var}/knot"
    EOS
  end

  service do
    run opt_sbin/"knotd"
    require_root true
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot.log"
  end

  test do
    system bin/"kdig", "@94.140.14.140", "www.knot-dns.cz", "+quic"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end

__END__
diff --git a/src/knot/server/quic-handler.c b/src/knot/server/quic-handler.c
index 0944900..f8ab263 100644
--- a/src/knot/server/quic-handler.c
+++ b/src/knot/server/quic-handler.c
@@ -13,6 +13,9 @@
     You should have received a copy of the GNU General Public License
     along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
+#ifdef __APPLE__
+#define __APPLE_USE_RFC_3542 /* to use IPV6_PKTINFO */
+#endif

 #include <netinet/in.h>
 #include <string.h>
diff --git a/src/knot/server/udp-handler.c b/src/knot/server/udp-handler.c
index 3b06fa9..5d85877 100644
--- a/src/knot/server/udp-handler.c
+++ b/src/knot/server/udp-handler.c
@@ -14,7 +14,9 @@
     along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */

-#define __APPLE_USE_RFC_3542
+#ifdef __APPLE__
+#define __APPLE_USE_RFC_3542 /* to use IPV6_PKTINFO */
+#endif

 #include <assert.h>
 #include <dlfcn.h>
