class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.11.0.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.11.0.tar.xz"
  sha256 "4130e1a6241280359ef5e25daec685533c0a1930674916202ab0579e5a232c51"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "42fe6e5f26ad7e65f3caa27ccddcec2f56d802267e47bc60202e5ec879d40b66"
    sha256 arm64_big_sur:  "6889e553cc2a0b22739311d3bd9627277413044eb96ee7cbd87621258a6f081d"
    sha256 monterey:       "c781fcdd918e80b1446156e43f63cbd391338418e13837c51a7ec8e038ded797"
    sha256 big_sur:        "01dedef365aa7e1656a5d70d802875ad0d58268f158fb4c3c4815e7a75e70c06"
    sha256 catalina:       "f573cfb607d1a5ba5b3d295956063804c67d9f0087513da20b57740e9f509950"
    sha256 x86_64_linux:   "6d2c852650f5cda77a1688ab1426e879b2f6657f196c7701fbf2b3cdf5f1c507"
  end

  depends_on "pkg-config" => :build
  depends_on "groff"
  depends_on "libpipeline"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gdbm"
  end

  def install
    man_db_conf = etc/"man_db.conf"
    args = %W[
      --disable-silent-rules
      --disable-cache-owner
      --disable-setuid
      --disable-nls
      --program-prefix=g
      --localstatedir=#{var}
      --with-config-file=#{man_db_conf}
      --with-systemdtmpfilesdir=#{etc}/tmpfiles.d
      --with-systemdsystemunitdir=#{etc}/systemd/system
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Use Homebrew's `var` directory instead of `/var`.
    inreplace man_db_conf, "/var", var

    # Symlink commands without 'g' prefix into libexec/bin and
    # man pages into libexec/man
    %w[apropos catman lexgrog man mandb manpath whatis].each do |cmd|
      (libexec/"bin").install_symlink bin/"g#{cmd}" => cmd
    end
    (libexec/"sbin").install_symlink sbin/"gaccessdb" => "accessdb"
    %w[apropos lexgrog man manconv manpath whatis zsoelim].each do |cmd|
      (libexec/"man"/"man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
    end
    (libexec/"man"/"man5").install_symlink man5/"gmanpath.5" => "manpath.5"
    %w[accessdb catman mandb].each do |cmd|
      (libexec/"man"/"man8").install_symlink man8/"g#{cmd}.8" => "#{cmd}.8"
    end

    # Symlink non-conflicting binaries and man pages
    %w[catman lexgrog mandb].each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
    end
    sbin.install_symlink "gaccessdb" => "accessdb"

    %w[accessdb catman mandb].each do |cmd|
      man8.install_symlink "g#{cmd}.8" => "#{cmd}.8"
    end
    man1.install_symlink "glexgrog.1" => "lexgrog.1"
  end

  def caveats
    <<~EOS
      Commands also provided by macOS have been installed with the prefix "g".
      If you need to use these commands with their normal names, you
      can add a "bin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/bin:$PATH"
    EOS
  end

  test do
    ENV["PAGER"] = "cat"
    if OS.mac?
      output = shell_output("#{bin}/gman true")
      assert_match "BSD General Commands Manual", output
      assert_match(/The true utility always returns with (an )?exit code (of )?zero/, output)
    end
    output = shell_output("#{bin}/gman gman")
    assert_match "gman - an interface to the system reference manuals", output
    assert_match "https://savannah.nongnu.org/bugs/?group=man-db", output
  end
end
