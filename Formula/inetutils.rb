class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-1.9.4.tar.xz"
  sha256 "849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37"
  revision 1

  bottle do
    rebuild 1
    sha256 "1fb6a52220a38f7d8fa26bde3adfa1c0c72f81a4da838c7983777ee6efad294f" => :mojave
    sha256 "bff5f977b2b1940691644c7292dfba7351eb991b1a9e2ae77df6fff2bc24207f" => :high_sierra
    sha256 "d58bb35606d1e119b535405487faeeb98334b8f17d805dab37d4a4827ba5c680" => :sierra
  end

  depends_on "libidn"

  def noshadow
    # List of binaries that do not shadow macOS utils
    list = %w[dnsdomainname rcp rexec rlogin rsh]
    list += %w[ftp telnet] if MacOS.version >= :high_sierra
    list
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --program-prefix=g
      --with-idn
    ]

    system "./configure", *args
    system "make", "install"

    # Binaries not shadowing macOS utils symlinked without 'g' prefix
    noshadow.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end

    # Symlink commands without 'g' prefix into libexec/gnubin and
    # man pages into libexec/gnuman
    bin.find.each do |path|
      next unless File.executable?(path) && !File.directory?(path)
      cmd = path.basename.to_s.sub(/^g/, "")
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats; <<~EOS
    The following commands have been installed with the prefix 'g'.

        #{noshadow.sort.join("\n    ")}

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    output = pipe_output("#{libexec}/gnubin/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
    assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
  end
end
