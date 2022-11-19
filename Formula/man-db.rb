class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.11.1.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.11.1.tar.xz"
  sha256 "2eabaa5251349847de9c9e43c634d986cbcc6f87642d1d9cb8608ec18487b6cc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "cdcde7118e97b5f3c887c428de68a2028a26cc452de78971dbcf48cc0608b7a9"
    sha256 arm64_monterey: "091ef85f9ead9918704ed11dafb1e47c75353e2ad2cc9fb0734778d2af77257a"
    sha256 arm64_big_sur:  "2813a0a078e8f7bfa54ede44e7b7ac78b52ad9985bb176d1e8ff3201f3b7c13f"
    sha256 ventura:        "cb41bceffbded2f753f8a5a244db5dc19b1b2410ebec867e0f0de995c0cfbb9b"
    sha256 monterey:       "8a153ba7e269e34ce36ffe7e9fe2c9b6d5587dfa00232472a9154bf770f375c3"
    sha256 big_sur:        "f9ed6e200a6d53908c5cdfbcb17da39de9286bca99faf9b5e89d698c7c7d7cd6"
    sha256 catalina:       "56bf6723559d403435f3e1c6c28e7969115e78650bdc07f95c60d3955e9b55eb"
    sha256 x86_64_linux:   "2d5b3235fc825e788d7285d652b1bf6bb6adb3839d3e48abac9a98c649e0e1bd"
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
    else
      output = shell_output("#{bin}/gman gman")
      assert_match "gman - an interface to the system reference manuals", output
      assert_match "https://savannah.nongnu.org/bugs/?group=man-db", output
    end
  end
end
