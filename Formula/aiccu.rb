class Aiccu < Formula
  desc "Automatic IPv6 Connectivity Client Utility"
  homepage "https://www.sixxs.net/tools/aiccu/"
  # Upstream 402s when passed a non-standard User-Agent such as Homebrew's
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/aiccu/aiccu_20070115.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/aiccu/aiccu_20070115.orig.tar.gz"
  version "20070115"
  sha256 "d23cf50a16fa842242c97683c3c1c1089a7a4964e3eaba97ad1f17110fdfe3cc"

  bottle do
    rebuild 1
    sha256 "ee19bef55805a8562bddb41a3af66e5bce9589b1e4d96b05348a37b5ada2c091" => :sierra
    sha256 "572e103e9de9c872eb202e18d5c4f352f0b9dc26d284d5979b83ff6fa3daa5b2" => :el_capitan
    sha256 "e4db05626f082c10398f46ac40aa25ec271be6e4372330d6d7c27b2349d0e789" => :yosemite
  end

  # Patches per MacPorts
  patch :DATA

  def install
    inreplace "doc/aiccu.conf", "daemonize true", "daemonize false"
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    etc.install "doc/aiccu.conf"
  end

  def caveats
    <<-EOS.undent
      You may also wish to install tuntap:

        The TunTap project provides kernel extensions for macOS that allow
        creation of virtual network interfaces.

        https://tuntaposx.sourceforge.io/

      You can install tuntap with homebrew using brew install tuntap

      Unless it exists already, a aiccu.conf file has been written to:
        #{etc}/aiccu.conf

      Protect this file as it will contain your credentials.

      The 'aiccu' command will load this file by default unless told to use
      a different one.
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/aiccu</string>
        <string>start</string>
        <string>#{etc}/aiccu.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/aiccu", "version"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 0e96136..78609bd 100644
--- a/Makefile
+++ b/Makefile
@@ -36,10 +36,11 @@ export DESTDIR
 CFLAGS=${RPM_OPT_FLAGS}

 # Destination Paths (relative to DESTDIR)
-dirsbin=/usr/sbin/
-dirbin=/usr/bin/
-diretc=/etc/
-dirdoc=/usr/share/doc/${PROJECT}/
+prefix=
+dirsbin=${prefix}/sbin/
+dirbin=${prefix}/bin/
+diretc=${prefix}/etc/
+dirdoc=${prefix}/share/doc/${PROJECT}/

 # Make sure the lower makefile also knows these
 export PROJECT
@@ -79,21 +80,13 @@ install: aiccu
	@echo "Configuration..."
	@mkdir -p ${DESTDIR}${diretc}
 ifeq ($(shell echo "A${RPM_BUILD_ROOT}"),A)
-	$(shell [ -f ${DESTDIR}${diretc}${PROJECT}.conf ] || cp -R doc/${PROJECT}.conf ${DESTDIR}${diretc}${PROJECT}.conf)
	@echo "Documentation..."
+	@cp doc/${PROJECT}.conf ${DESTDIR}${dirdoc}
	@cp doc/README ${DESTDIR}${dirdoc}
	@cp doc/LICENSE ${DESTDIR}${dirdoc}
	@cp doc/HOWTO  ${DESTDIR}${dirdoc}
-	@echo "Installing Debian-style init.d"
-	@mkdir -p ${DESTDIR}${diretc}init.d
-	@cp doc/${PROJECT}.init.debian ${DESTDIR}${diretc}init.d/${PROJECT}
-else
-	@echo "Installing Redhat-style init.d"
-	@mkdir -p ${DESTDIR}${diretc}init.d
-	@cp doc/${PROJECT}.init.rpm ${DESTDIR}${diretc}init.d/${PROJECT}
-	@cp doc/${PROJECT}.conf ${DESTDIR}${diretc}${PROJECT}.conf
 endif
-	@echo "Installation into ${DESTDIR}/ completed"
+	@echo "Installation into ${DESTDIR}${prefix}/ completed"

 help:
	@echo "$(PROJECT) - $(PROJECT_DESC)"
diff --git a/common/aiccu.h b/common/aiccu.h
index ef65000..5b2eb43 100755
--- a/common/aiccu.h
+++ b/common/aiccu.h
@@ -65,17 +65,17 @@
  * the data. Could be useful in the event
  * where we can't make contact to the main server
  */
-#define AICCU_CACHE	"/var/cache/aiccu.cache"
+#define AICCU_CACHE	"HOMEBREW_PREFIX/var/cache/aiccu.cache"

 /* The PID we are running as when daemonized */
-#define AICCU_PID	"/var/run/aiccu.pid"
+#define AICCU_PID	"HOMEBREW_PREFIX/var/run/aiccu.pid"

 /* AICCU Configuration file */
 #ifdef _WIN32
 /* GetWindowsDirectory() is used to figure out the directory to store the config */
 #define AICCU_CONFIG	"aiccu.conf"
 #else
-#define AICCU_CONFIG	"/etc/aiccu.conf"
+#define AICCU_CONFIG	"HOMEBREW_PREFIX/etc/aiccu.conf"
 #endif

 /* Inbound listen queue */
