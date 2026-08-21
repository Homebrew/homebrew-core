class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftpmirror.gnu.org/gnu/inetutils/inetutils-2.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/inetutils/inetutils-2.8.tar.gz"
  sha256 "57b3cf4f77555992881e5ba2a09a63b05aa2c56342a60ed4305b5f45938390b5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "0a66dfe25ede29e4c90e7cf13c6a6944ca36a13307c07473a56a9f7244668766"
    sha256 arm64_sequoia: "c1d48a14177702ea7463d3b952bd270665dcfe5e55d8106f02ade499676f6fcc"
    sha256 arm64_sonoma:  "c165f99ceec005129fd4cc13562cb6a9b21ac6838c99e8dbb61217f315e55c06"
    sha256 sonoma:        "d3bb0b5770606e81c7e8c66a8e9845e409be6fd612bd083295e2b17fccdb344b"
    sha256 arm64_linux:   "73563aafff795dfc70e174a26345f2c5c9a8d90e46074dd5dd00c226ba3d7d06"
    sha256 x86_64_linux:  "3720ff504aa3da595a8f268348142cdf4640a853634117308a3d7b1c3fa02273"
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
