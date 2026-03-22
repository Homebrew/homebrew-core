class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftpmirror.gnu.org/gnu/inetutils/inetutils-2.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/inetutils/inetutils-2.7.tar.gz"
  sha256 "a156be1cde3c5c0ffefc262180d9369a60484087907aa554c62787d2f40ec086"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "679c93f5939a40a29d8405d0494cf42900d039adde87f2c6c80cb0ac78bea4d5"
    sha256 arm64_sequoia: "945627896b2789911b27c99c415ec4392c4950e2857d3ccd63810c695c00b4ac"
    sha256 arm64_sonoma:  "8d4c9f02566b20dde1c997e6902230d9bee5100eb659627dfeebc9469c366926"
    sha256 sonoma:        "bb1efe4e985bba255854ed3cb1b3b1a5e94a2be65b390a6f384746e1be4f3009"
    sha256 arm64_linux:   "2f583154f1494f33345fe3d74baba8805fb95be9cb152ffe1f7b3b4a4fa84d45"
    sha256 x86_64_linux:  "252b3d566a72404df73d6a4c5e4094a4bf84ed98a594ae6fb5c5174ea8ad85ae"
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
    %w[dnsdomainname ftp rcp rexec rlogin rsh telnet]
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
    system "./configure", "--disable-silent-rules",
                          "--with-idn",
                          "--program-prefix=g",
                          *std_configure_args
    system "make", "SUIDMODE=", "install"

    no_conflict = OS.mac? ? noshadow : []

    # Symlink server commands without 'g' prefix into sbin on Linux.
    # (ftpd, inetd, rexecd, rlogind, rshd, syslogd, talkd, telnetd, tftpd, uucpd)
    if OS.linux?
      libexec.find.each do |path|
        next if !path.executable? || path.directory?

        cmd = path.basename.to_s.sub(/^g/, "")
        sbin.install_symlink libexec/"g#{cmd}" => cmd
        man8.install_symlink man8/"g#{cmd}.8" => "#{cmd}.8"
      end
    end

    # Symlink commands without 'g' prefix into libexec/gnubin and
    # man pages into libexec/gnuman
    bin.find.each do |path|
      next if !path.executable? || path.directory?

      cmd = path.basename.to_s.sub(/^g/, "")
      no_conflict << cmd unless OS.mac?
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
      (libexec/"gnuman/man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
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
