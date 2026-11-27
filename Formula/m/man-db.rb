class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://man-db.gitlab.io/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.13.3.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.13.3.tar.xz"
  sha256 "7c10ac705433c740af91264fc29eee471090ead63a408541ab9736284a8c9deb"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "2e6847fe4e633b5e0e34a6821d60087080197df9ec10ff75d4e48f42c8f53eb4"
    sha256 arm64_golden_gate: "9b67dd6448e96805aa09adbe66721057c8bc371e6e62f62aab9f167b2e7c695d"
    sha256 arm64_tahoe:       "1bb35850898ac2ff7f139facb81c0ffd97a703e42b2e088d772d8d706ffd32eb"
    sha256 arm64_sequoia:     "d20ee12ab73c56b9c7db6a572f09d9a867fe7cc700812ee0a4dffcbf363bb9ed"
    sha256 arm64_linux:       "6591ad3c4ca337ea96cddf677508812d31ec704546799f2e60cb8aeccf86f936"
    sha256 x86_64_linux:      "cf61f61908c778d779aeaec807eee3b3e8cb265151ce5df3eaf8dbf75ce401d4"
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
