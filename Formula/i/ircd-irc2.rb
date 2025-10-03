class IrcdIrc2 < Formula
  desc "Original IRC server daemon"
  homepage "https://web.archive.org/web/20240814044559/http://www.irc.org/"
  url "https://web.archive.org/web/20240805183402/http://www.irc.org/ftp/irc/server/irc2.11.2p3.tgz"
  version "2.11.2p3"
  sha256 "be94051845f9be7da0e558699c4af7963af7e647745d339351985a697eca2c81"
  # The `:cannot_represent` is for a Digital Equipment Corporation license.
  # TODO: See if SPDX will consider this a match for HPND License.
  license all_of: [
    "GPL-1.0-or-later",
    "GPL-2.0-or-later", # ircd/fileio.*, ircd/patricia.c
    "ISC", # ircd/res_comp.c
    "BSD-4-Clause-UC", # ircd/{res_comp.c,res_init.c,res_mkquery.c,resolv_def.h}
    :cannot_represent, # ircd/{res_comp.c,res_init.c,res_mkquery.c,resolv_def.h}
  ]

  bottle do
    rebuild 2
    sha256 arm64_tahoe:    "e60037ded349a9107379774d16764e0cd9506b7c24134f8f22f0f9d30b8214c1"
    sha256 arm64_sequoia:  "11a1e704e3078514219037593b14351817074e38045f95a056d048ced644fed1"
    sha256 arm64_sonoma:   "c45a5b7682ca7ac5d07f883a2aa981c835ef3ecf2b25602099eb8c27331e4398"
    sha256 arm64_ventura:  "692fa84b509e25774b65bd12c281990093c6f6563447d2a62ca6e1f13f04ea69"
    sha256 arm64_monterey: "bd6adad56faafcb7ac533e5bb8668e689b8017a6b0ad336715d02b00b824b882"
    sha256 sonoma:         "f5fcb1c6dea38be635adcc3bb4a6b32d8034d4c02ee5ea1034a66e6b64059cbd"
    sha256 ventura:        "fcde6372721ec2700d587fd077cb410df0afdc5100d8181576a5f905728e7ed9"
    sha256 monterey:       "90c0639ec3e7ab17eaa97b90af15b30b14896d23f7f3c492b88a3190555781ff"
    sha256 arm64_linux:    "6dab067580b38df4623c5256bb04d641f108ec8997491b483e91b58df06e9257"
    sha256 x86_64_linux:   "524aef733a367cce6eb115c4453ec851ffe7ac7d731c3d5ce91195be201bddb1"
  end

  def default_ircd_conf
    <<~EOS
      # M-Line
      M:irc.localhost::Darwin ircd default configuration::000A

      # A-Line
      A:This is Darwin's default ircd configurations:Please edit your /usr/local/etc/ircd.conf file:Contact <root@localhost> for questions::ExampleNet

      # Y-Lines
      Y:1:90::100:512000:5.5:100.100
      Y:2:90::300:512000:5.5:250.250

      # I-Line
      I:*:::0:1
      I:127.0.0.1/32:::0:1

      # P-Line
      P::::6667:
    EOS
  end

  # Last release on 2010-08-13 and site is down
  deprecate! date: "2025-04-06", because: :unmaintained

  uses_from_macos "libxcrypt"

  on_linux do
    on_arm do
      # Added automake as a build dependency to update config files for ARM support.
      depends_on "automake" => :build
    end
  end

  conflicts_with "ircd-hybrid", because: "both install `ircd` binaries"

  # Replace usage of nameser_def.h which has incompatible IBM license.
  # Ref: https://gitlab.com/fedora/legal/fedora-license-data/-/issues/53
  patch :DATA

  def install
    # Remove header with incompatible IBM license and add linker flags to use system library instead
    rm("ircd/nameser_def.h")
    ENV.append "LIBS", "-lresolv"

    if OS.linux? && Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, "support/#{fn}"
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "CFLAGS=-DRLIMIT_FDMAX=0"

    build_dir = `./support/config.guess`.chomp

    # Disable netsplit detection. In a netsplit, joins to new channels do not
    # give chanop status.
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_USERS\s+65000/,
      "#define DEFAULT_SPLIT_USERS 0"
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_SERVERS\s+80/,
      "#define DEFAULT_SPLIT_SERVERS 0"

    # The directory is something like `i686-apple-darwin13.0.2'
    system "make", "install", "-C", build_dir

    (buildpath/"ircd.conf").write default_ircd_conf
    etc.install "ircd.conf"
  end

  service do
    run [opt_sbin/"ircd", "-t"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"ircd.log"
  end

  test do
    system "#{sbin}/ircd", "-version"
  end
end

__END__
diff --git a/ircd/res_comp.c b/ircd/res_comp.c
index b58d06c..a0ff2b9 100644
--- a/ircd/res_comp.c
+++ b/ircd/res_comp.c
@@ -64,6 +64,7 @@ static const volatile char rcsid[] = "$Id: res_comp.c,v 1.10 2004/10/01 20:22:14
 #include "s_externs.h"
 #undef RES_COMP_C

+#if 0
 static int	ns_name_ntop (const u_char *, char *, size_t);
 static int	ns_name_pton (const char *, u_char *, size_t);
 static int	ns_name_unpack (const u_char *, const u_char *,
@@ -75,6 +76,7 @@ static int	ns_name_uncompress (const u_char *, const u_char *,
 static int	ns_name_compress (const char *, u_char *, size_t,
 				      const u_char **, const u_char **);
 static int	ns_name_skip (const u_char **, const u_char *);
+#endif

 /*
  * Expand compressed domain name 'comp_dn' to full domain name.
@@ -306,6 +308,7 @@ static int		dn_find (const u_char *, const u_char *,

 /* Public. */

+#if 0
 /*
  * ns_name_ntop(src, dst, dstsiz)
  *	Convert an encoded domain name to printable ascii as per RFC1035.
@@ -749,6 +752,7 @@ static int	ns_name_skip(const u_char **ptrptr, const u_char *eom)
 	*ptrptr = cp;
 	return (0);
 }
+#endif

 /* Private. */

diff --git a/ircd/s_defines.h b/ircd/s_defines.h
index aaaf0d4..acd1378 100644
--- a/ircd/s_defines.h
+++ b/ircd/s_defines.h
@@ -37,4 +37,5 @@
 #include "service_def.h"
 #include "sys_def.h"
 #include "resolv_def.h"
-#include "nameser_def.h"
+#define BIND_8_COMPAT
+#include <arpa/nameser.h>
