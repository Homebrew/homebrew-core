class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-1.9.4.tar.xz"
  sha256 "849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37"

  bottle do
    sha256 "899841c7d0ae008687349fa8858da32989b447bc2214c93767547235dd68aea3" => :sierra
    sha256 "16234b74de732ad320598e361e2585f29dc6d1d74fcb63bebd351ec7a2c89aeb" => :el_capitan
    sha256 "5f0e947e5e686a2abc9994c6045fbe624037d1fbca0a649913589fb1cd209731" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "libidn"

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
      noshadow = %w[dnsdomainname rcp rexec rlogin rsh]
      noshadow += %w[ftp telnet] if MacOS.version >= :high_sierra
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

  test do
    output = pipe_output("#{libexec}/gnubin/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
    assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
  end
end
