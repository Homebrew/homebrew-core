class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-1.9.4.tar.xz"
  sha256 "849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37"

  bottle do
    rebuild 1
    sha256 "f57b7d080b62fc569e9f1085a2edda0f6c5bdf0ff93d76ee9df009983ae14c99" => :high_sierra
    sha256 "e138ac43402b4a19991ad5fcbcdb7e1e5e2a4e13f71b4423db5102aef9da0db0" => :sierra
    sha256 "5fdac142afc7e9a376534e825d90c91b89e7fcae4f9ccebaadf568017ee6de78" => :el_capitan
    sha256 "1c9d32aa9b97b6119cad466b9a5efeef6bf74f54dbeccd096860e1500658d866" => :yosemite
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
