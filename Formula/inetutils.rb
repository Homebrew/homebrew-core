class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-1.9.4.tar.xz"
  sha256 "849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37"
  revision 1

  bottle do
    sha256 "7516d588827d17639de90dbec68a726763880500d1423773390e55b5ef97c8d9" => :mojave
    sha256 "83a83d549780840164b9b3da28d3aef47e41378415d6cdb6c6aee48d04623340" => :high_sierra
    sha256 "538f028274c5afbc0d4eb397b142f724d48c68a85acc6e1c5c30e00e652d5afb" => :sierra
    sha256 "08419e32bd90cdc6c6b4715e64b2facae634a3cd45ecc7e54da87cab7b112458" => :el_capitan
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

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
      --with-idn
    ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    if build.without? "default-names"
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
    end
  end

  def caveats
    if build.without? "default-names" then <<~EOS
      The following commands have been installed with the prefix 'g'.

          #{noshadow.sort.join("\n    ")}

      If you really need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"

      Additionally, you can access their man pages with normal names if you add
      the "gnuman" directory to your MANPATH from your bashrc as well:

          MANPATH="#{opt_libexec}/gnuman:$MANPATH"
    EOS
    end
  end

  test do
    output = pipe_output("#{libexec}/gnubin/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
    assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
  end
end
