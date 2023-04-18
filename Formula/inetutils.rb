class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.4.tar.xz"
  sha256 "1789d6b1b1a57dfe2a7ab7b533ee9f5dfd9cbf5b59bb1bb3c2612ed08d0f68b2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "872275661200b6f4372aee795840075b23dd2c4862ded07f4000d706ba37409e"
    sha256 arm64_monterey: "b9ffd46bc37271e9c1f57a333d39af249ef131fa68a89565bcf06fcf0cb7e4da"
    sha256 arm64_big_sur:  "02e7db5f94d356b61cf55ba51c85df000ddce5df9fd9925c81d415fa15b6aa5e"
    sha256 ventura:        "8c34d17dd5c58955e33eb77b68dc06a43e1c8f193bf3f12c314f0fa45efd9404"
    sha256 monterey:       "538573e4777f6f7ba4d5ab5ec8546b3e614a219dfedcfdb08c968210a4f012de"
    sha256 big_sur:        "f6e3c7e2ae01a7d3e7801122bf93b525bd353dc995724e25a719d7b6362167bd"
    sha256 catalina:       "0b8cb0db259708450273e70e7d037a6806137c09ab16a6fc53d4a5093f2aa46a"
    sha256 x86_64_linux:   "f1dfc69baed24c9608d2f5ecf54a650960780de44fced9a712bb91a4e52e3fac"
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
