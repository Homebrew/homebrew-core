class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://man-db.gitlab.io/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.13.1.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.13.1.tar.xz"
  sha256 "8afebb6f7eb6bb8542929458841f5c7e6f240e30c86358c1fbcefbea076c87d9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7dc229cef4b93ffab9ab1e0915128e0f82bfc97e07f5b2db18d0e97125b7ceb7"
    sha256 arm64_sequoia: "20328186ff7f4a29fd029d966fb8bb7ab57e3878023a480f362e6821bb035eba"
    sha256 arm64_sonoma:  "3d091053cb022d2aec755c6820db73d90cfee5cee8e87c554c05ce15d940f495"
    sha256 sonoma:        "7ab7d61c5d34832f182a5d43814aedafc83ee39935515dea044914b5fe9e914b"
    sha256 arm64_linux:   "89bb5bab792be06d435eecaa9f485283fd4dcca1881992eec2d3b492fe238862"
    sha256 x86_64_linux:  "381c521219f42b0b19f06ccfef76cfd89ce762cac6d30ddccb696b9219748135"
  end

  depends_on "pkgconf" => :build
  depends_on "groff"
  depends_on "libpipeline"

  on_linux do
    depends_on "gdbm"
    depends_on "zlib-ng-compat"
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
