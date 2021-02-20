class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.0.tar.xz"
  sha256 "e573d566e55393940099862e7f8994164a0ed12f5a86c3345380842bdc124722"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "82b61f26f0dc565334619a3ca34994cfea99088e25db94bd15706037a2c49b61"
    sha256 cellar: :any, big_sur:       "31f0fdd6e2bdc5ed3e25d46aa8c47c2e0d6c9fe13011fe4c388388eead919676"
    sha256 cellar: :any, catalina:      "8fd3005c6e2914ee9d3d2f513bfa903827a94a74a232f1553d9a113aba1eddc2"
    sha256 cellar: :any, mojave:        "85a50b1e624497625bea4c836be1005dfd60c11814778e09153acf256a9e3992"
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
    system "make", "install"

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
