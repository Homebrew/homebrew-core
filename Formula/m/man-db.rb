class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://man-db.gitlab.io/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.13.2.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.13.2.tar.xz"
  sha256 "881df6b370b40cd73db8c543c02c94af5fc5a7c96189a7e2e9af12481f611d8b"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "123aa166978cfed749bc7e32ca42dda5870770c8ec5e44fe5d644e5764ae8caf"
    sha256 arm64_tahoe:       "c74fbf054a85dbca64c322e31e807ac0932498a08cafd056b47be65496ef959c"
    sha256 arm64_sequoia:     "cf461ebb6ab6fd107b5f4428e6dca28443de69249326087d989a25b114c435d4"
    sha256 arm64_linux:       "497eeabd99f14092bdf1534e2a807b29d5581d483679f647392be74937e12fb3"
    sha256 x86_64_linux:      "d17bfeb7c297364767df4300a2093ec26123b56e507ed3dba66398aeb83d5ab1"
  end

  depends_on "pkgconf" => :build
  depends_on "groff"
  depends_on "libpipeline"

  on_linux do
    depends_on "gdbm"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
      (libexec/"man/man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
    end
    (libexec/"man/man5").install_symlink man5/"gmanpath.5" => "manpath.5"
    %w[accessdb catman mandb].each do |cmd|
      (libexec/"man/man8").install_symlink man8/"g#{cmd}.8" => "#{cmd}.8"
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
      assert_match "General Commands Manual", output
      assert_match(/The true utility always returns with (an )?exit code (of )?zero/, output)
    else
      output = shell_output("#{bin}/gman gman")
      assert_match "gman - an interface to the system reference manuals", output
    end
  end
end
