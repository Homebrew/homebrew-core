class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftpmirror.gnu.org/gnu/inetutils/inetutils-2.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/inetutils/inetutils-2.6.tar.xz"
  sha256 "68bedbfeaf73f7d86be2a7d99bcfbd4093d829f52770893919ae174c0b2357ca"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "8de72231a19193dc6b8bbc2ca68869494572f7847870529fe4917e8ef980ed0a"
    sha256 arm64_sequoia: "d6effc6962c93d36abc4c5912fad2235fb8a22660e0564134e04d4bab636b6b3"
    sha256 arm64_sonoma:  "c597d9559731d11246683d104edfe3a0cefc5051cf2c522e865540a19e39b225"
    sha256 arm64_ventura: "2fcf900ec14e1c171d02ca16dc8f39123de7a3efd2a9881770fe6ed095bab2b4"
    sha256 sonoma:        "67ec5c370542a4a6e30bb446748481336eebc34d5b7e26c83f2209990cf76272"
    sha256 ventura:       "01116c7159a47d9ad41d61ef5d7e6c671e06f80a0473d0e6459e1d51e2a48aa2"
    sha256 arm64_linux:   "7016cbea9291ebb752d5cb881caf5537fd816027e09b8b89869ce2d09f0a7a82"
    sha256 x86_64_linux:  "d14270a7f2d5b24df4526319374f9038b2ebc430e5e2432262eff1d78195232a"
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
