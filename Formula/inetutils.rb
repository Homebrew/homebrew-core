class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.0.tar.xz"
  sha256 "e573d566e55393940099862e7f8994164a0ed12f5a86c3345380842bdc124722"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_big_sur: "67cf68d882126411ce4f2d0dd0aba683170f1c049c01e4fdbb156ace7a6e9ab0"
    sha256 big_sur:       "6cb6cdaeeddf24484e33d5a90c5380d1004cf34c85604a2620545ec7716bdd86"
    sha256 catalina:      "dd6368d46eb1e7857dc301ade6377731028d30326d8e7bc010264bdf8590623a"
    sha256 mojave:        "76c0686105882d914260ad551a78e9954bd08e9757c45c35fa606941a6d36993"
  end

  depends_on "libidn"

  conflicts_with "telnet", because: "both install `telnet` binaries"
  conflicts_with "tnftp", because: "both install `ftp` binaries"

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

    on_macos do
      args << "--program-prefix=g"
    end
    system "./configure", *args
    system "make", "SUIDMODE=", "install"

    on_macos do
      # Binaries not shadowing macOS utils symlinked without 'g' prefix
      noshadow.each do |cmd|
        bin.install_symlink "g#{cmd}" => cmd
        man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
      end

      # Symlink commands without 'g' prefix into libexec/gnubin and
      # man pages into libexec/gnuman
      bin.find.each do |path|
        next if !File.executable?(path) || File.directory?(path)

        cmd = path.basename.to_s.sub(/^g/, "")
        (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
        (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    <<~EOS
      The following commands have been installed with the prefix 'g'.

          #{noshadow.sort.join("\n    ")}

      If you really need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    on_macos do
      output = pipe_output("#{libexec}/gnubin/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
      assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
    end
    on_linux do
      output = pipe_output("#{bin}/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
      assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
    end
  end
end
