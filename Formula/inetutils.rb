class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.2.tar.xz"
  sha256 "d547f69172df73afef691a0f7886280fd781acea28def4ff4b4b212086a89d80"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "6bc3499a13f6fddc89d967fe8bc9633ddd5970d9a40e596cca7e2b32484b6051"
    sha256 arm64_big_sur:  "40b658c6c497bff3c916956203f971517a3c1d0f6bf46f0d675ec25c888fffae"
    sha256 monterey:       "44587f414ae56e0e323755737282bb069739bac0a5a8e220e1951af1f00b49bd"
    sha256 big_sur:        "4f4ded12f0164096243102d086f95d54ed6def282b758d3b69a88133b3fc2f3d"
    sha256 catalina:       "274d56c19d93ffb4c32f3a896872cf78222a28bee436ae363c35455d279f4ed7"
    sha256 mojave:         "077af2b47b07e9c4d2f3f574561ba6d6c90e879e93a4be0b2454a9e13b7842ea"
    sha256 x86_64_linux:   "d2ef16a78009201d1b6a594cc44bc8fc44c6a730b91c96e23588f1c71de6d234"
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

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "SUIDMODE=", "install"

    if OS.mac?
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
