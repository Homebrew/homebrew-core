class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.5.tar.xz"
  sha256 "87697d60a31e10b5cb86a9f0651e1ec7bee98320d048c0739431aac3d5764fb6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "a6def7fbd9a1c7ef2f4e9c582fc5e40ae572b95d0eaf6dedf5349c08f70179d0"
    sha256 arm64_sonoma:   "e6afa68602fd3a2789d7488c2080fb88acab6021aadc8e4c8cdb7fb5c1168e39"
    sha256 arm64_ventura:  "9b554572efb13f9762a17d4abfa721c1e9b4d757a78ac67eb56bfcd777852ba4"
    sha256 arm64_monterey: "8dd6e104cc9092a2225c205dfa346ad7a9f0134f0608e8f58e454f6c749b6714"
    sha256 sonoma:         "251dcd9d1fee54a85c35ccc0c29e5ca1f9bbccc7edb71ae714ee6cab51f52e54"
    sha256 ventura:        "f77f7f7460b637f6d90997cd8b0ab2edf1a94ce62b79d5d167e1f02b0ab9a475"
    sha256 monterey:       "6f6271408faa0f220506dd46ca5eb1fbf353f77071139c94d84406a10a7c3cfd"
    sha256 x86_64_linux:   "d76a8cb2d5cf6eb61e23d0cd6fa0527dea4e0649830a5e562d423df4cadcb0ce"
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
  conflicts_with "gping", because: "both install `gping` binaries"

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
    (libexec/"gnubin").install_symlink "../gnuman" => "man"

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
