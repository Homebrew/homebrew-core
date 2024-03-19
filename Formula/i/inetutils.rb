class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.5.tar.xz"
  sha256 "87697d60a31e10b5cb86a9f0651e1ec7bee98320d048c0739431aac3d5764fb6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "eb362cd58b231f8472ff804a0556c2d028803781e66019f1aeb6faf8e60263ae"
    sha256 arm64_ventura:  "352aa9dadeca1469fed9beb698ef3771b920e764dfc2d828824b5f7974020524"
    sha256 arm64_monterey: "b69db528c4cf1e7bbdfa4e2b410fa55a0458610c09589b041c2d9c170c815b25"
    sha256 sonoma:         "4c6873d55b69d42e53e91fd4557eef9db185e995aede9e9ddb0edd298819c6e1"
    sha256 ventura:        "0f9ca71c5ea6aa16379b60f604f1af305878983cbe0f48ab234da91968e6d3d8"
    sha256 monterey:       "ce0fe97b4c1706fb77d17a8672148be394bd8a5e81bdcf44e9ad8cb3facf730d"
    sha256 x86_64_linux:   "494e2ab0b32fdc71e6c715f06ed8aa51e1fea2d525c9061073921220de93f135"
  end

  depends_on "help2man" => :build
  depends_on "libidn2"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  conflicts_with "telnet", because: "both install `telnet` binaries"
  conflicts_with "tnftp", because: "both install `ftp` binaries"

  def noshadow
    # List of binaries that do not shadow macOS utils
    list = %w[dnsdomainname rcp rexec rlogin rsh]
    on_high_sierra :or_newer do
      list += %w[ftp telnet]
    end
    list
  end

  def linux_conflicts
    # List of binaries that conflict with other common implementations
    list = %w[dnsdomainname hostname ifconfig] # net-tools
    list << "logger" # util-linux
    list << "ping" # iputils
    list << "whois" # whois
    list
  end

  # upstream bug report, https://savannah.gnu.org/bugs/index.php?65093
  patch :DATA

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-idn",
                          "--program-prefix=g"
    system "make", "SUIDMODE=", "install"

    no_conflict = OS.mac? ? noshadow : []

    # Symlink server commands without 'g' prefix into sbin on Linux.
    # (ftpd, inetd, rexecd, rlogind, rshd, syslogd, talkd, telnetd, tftpd, uucpd)
    if OS.linux?
      libexec.find.each do |path|
        next if !File.executable?(path) || File.directory?(path)

        cmd = path.basename.to_s.sub(/^g/, "")
        sbin.install_symlink libexec/"g#{cmd}" => cmd
        man8.install_symlink man8/"g#{cmd}.8" => "#{cmd}.8"
      end
    end

    # Symlink commands without 'g' prefix into libexec/gnubin and
    # man pages into libexec/gnuman
    bin.find.each do |path|
      next if !File.executable?(path) || File.directory?(path)

      cmd = path.basename.to_s.sub(/^g/, "")
      no_conflict << cmd unless OS.mac?
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
    end
    libexec.install_symlink "gnuman" => "man"

    no_conflict -= linux_conflicts if OS.linux?
    # Symlink binaries that are not shadowing macOS utils or are
    # non-conflicting with common alternatives on Linux.
    no_conflict.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats
    s = ""
    on_macos do
      s += <<~EOS
        Only the following commands have been installed without the prefix 'g'.

            #{noshadow.sort.join("\n    ")}

        If you really need to use other commands with their normal names,
      EOS
    end
    on_linux do
      s += <<~EOS
        The following commands have been installed with the prefix 'g'.

            #{linux_conflicts.sort.join("\n    ")}

        If you really need to use these commands with their normal names,
      EOS
    end
    s += <<~EOS
      you can add a "gnubin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
    s
  end

  test do
    ftp = OS.mac? ? libexec/"gnubin/ftp" : bin/"ftp"
    output = pipe_output("#{ftp} -v", "open ftp.gnu.org\nanonymous\nls\nquit\n")
    assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
  end
end

__END__
diff --git a/src/syslogd.c b/src/syslogd.c
index 918686d..dd8c359 100644
--- a/src/syslogd.c
+++ b/src/syslogd.c
@@ -278,7 +278,9 @@ void logerror (const char *);
 void logmsg (int, const char *, const char *, int);
 void printline (const char *, const char *);
 void printsys (const char *);
+#if !__APPLE__
 char *ttymsg (struct iovec *, int, char *, int);
+#endif
 void wallmsg (struct filed *, struct iovec *);
 char **crunch_list (char **oldlist, char *list);
 char *textpri (int pri);
