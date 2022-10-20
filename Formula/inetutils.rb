class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.3.tar.xz"
  sha256 "0b01bb08e29623c4e3b940f233c961451d9af8c5066301add76a52a95d51772c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "f65ead160cc97512b1f455e484c659cef4246697d5532f70c3c3064a5662ecf9"
    sha256 arm64_big_sur:  "8ad299624b9ef886e12c3c8e867e37221a39c4e37c92d9e66a5cfd35c1e476e7"
    sha256 monterey:       "61e729a04247afbb2db834c925e836d0161599e4bc1d358358567361077233cb"
    sha256 big_sur:        "609ff12f247833342fab12cca0e9af35dc5b7381d1dc2832ffeac0b766de30b2"
    sha256 catalina:       "7e0d2f2d59563967d311dfe659f41afdfc9cd7fa72432e5c62ce840364a6d349"
    sha256 x86_64_linux:   "d96fc5cc1098b454f443979ce5900d2a5f9d24389b4e72c4bd3dac40cdf74e10"
  end

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
