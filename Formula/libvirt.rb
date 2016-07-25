class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-2.0.0.tar.xz"
  sha256 "10e90af55e613953c0ddc60b4ac3a10c73c0f3493d7014259e3f012b2ffc9acb"

  bottle do
    sha256 "7acc4fefda57345d86297de6bfd267f5abcbc902daf4b976fc45807525ec5440" => :el_capitan
    sha256 "8d26242b5803553bff45752d5df616be38efe6be902a937fc319a09ef47f1968" => :yosemite
    sha256 "cef64589bd74610e97526c7e9f0c1178fd30bfbda26e7b0db393579f8271e759" => :mavericks
  end

  option "without-libvirtd", "Build only the virsh client and development libraries"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

  if MacOS.version <= :leopard
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # Fixes compile failure.  Will be in next upstream release:
  #  https://www.redhat.com/archives/libvir-list/2016-July/msg00815.html
  patch :p1, :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-esx
      --with-init-script=none
      --with-remote
      --with-test
      --with-vbox
      --with-vmware
      --with-yajl
      --without-qemu
    ]

    args << "--without-libvirtd" if build.without? "libvirtd"

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf", "/etc/", "#{HOMEBREW_PREFIX}/etc/"

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    if build.with? "libvirtd"
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
  end

  test do
    output = shell_output("#{bin}/virsh -v")
    assert_match version.to_s, output
  end
end

__END__
diff --git a/src/util/virsystemd.c b/src/util/virsystemd.c
index 969cd68..7d6985b 100644
--- a/src/util/virsystemd.c
+++ b/src/util/virsystemd.c
@@ -41,6 +41,10 @@

 VIR_LOG_INIT("util.systemd");

+#ifndef MSG_NOSIGNAL
+# define MSG_NOSIGNAL 0
+#endif
+
 static void virSystemdEscapeName(virBufferPtr buf,
                                  const char *name)
 {
