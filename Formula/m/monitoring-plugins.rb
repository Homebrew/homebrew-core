class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.3.5.tar.gz"
  sha256 "f3edd79a9254f231a1b46b32d14def806648f5267e133ef0c0d39329587ee38b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.monitoring-plugins.org/download.html"
    regex(/href=.*?monitoring-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8964ad146aab38fc46b9d3794d94607b038e578f807b12df7335cbe747fea689"
    sha256 arm64_ventura:  "42ace3f93ed42a299e9e055c44f85c62ccdfe120bef31f1ee272c731f5ef8bb0"
    sha256 arm64_monterey: "38c990c7c13cc49e958997972fb95207aaf35b0071aefd0a1e02d2a007915a14"
    sha256 sonoma:         "fda974f1768ad4544c67476ddd08a8107131474a51d860f99cdd8982a1f28b83"
    sha256 ventura:        "8713781f32bed97eccc5f12040b264f942f3709298bb0bef4abcfad9603e2b74"
    sha256 monterey:       "b07aa720eb6a8dd39fc0f865cae3403e0a51e0cc559d382fa1a30dd195c50635"
    sha256 x86_64_linux:   "ab67fd985f70e7756cace887a597f7ea4391a019cf0e29ef2ade27fcd1eecc85"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl@3"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  # Prevent -lcrypto from showing up in Makefile dependencies
  # Reported upstream: https://github.com/monitoring-plugins/monitoring-plugins/pull/1970
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    system "aclocal", "-I", "gl/m4", "-I", "m4"
    system "autoupdate"
    system "automake", "--add-missing"
    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H brew.sh -s 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end

__END__
diff --git a/plugins-root/Makefile.am b/plugins-root/Makefile.am
index 40aa020..a80229e 100644
--- a/plugins-root/Makefile.am
+++ b/plugins-root/Makefile.am
@@ -26,7 +26,7 @@ EXTRA_PROGRAMS = pst3
 
 EXTRA_DIST = t pst3.c
 
-BASEOBJS = ../plugins/utils.o ../lib/libmonitoringplug.a ../gl/libgnu.a $(LIB_CRYPTO)
+BASEOBJS = ../plugins/utils.o ../lib/libmonitoringplug.a ../gl/libgnu.a
 NETOBJS = ../plugins/netutils.o $(BASEOBJS) $(EXTRA_NETOBJS)
 NETLIBS = $(NETOBJS) $(SOCKETLIBS)
 
@@ -80,8 +80,8 @@ install-exec-local: $(noinst_PROGRAMS)
 
 ##############################################################################
 # the actual targets
-check_dhcp_LDADD = @LTLIBINTL@ $(NETLIBS)
-check_icmp_LDADD = @LTLIBINTL@ $(NETLIBS) $(SOCKETLIBS)
+check_dhcp_LDADD = @LTLIBINTL@ $(NETLIBS) $(LIB_CRYPTO)
+check_icmp_LDADD = @LTLIBINTL@ $(NETLIBS) $(SOCKETLIBS) $(LIB_CRYPTO)
 
 # -m64 needed at compiler and linker phase
 pst3_CFLAGS = @PST3CFLAGS@
