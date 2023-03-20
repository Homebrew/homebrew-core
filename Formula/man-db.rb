class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.11.2.tar.xz", using: :homebrew_curl
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.11.2.tar.xz"
  sha256 "cffa1ee4e974be78646c46508e6dd2f37e7c589aaab2938cc1064f058fef9f8d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "77905671d6ddbaf21dabfe06f67346a505110753d2dbf577084a69ff6d8f52e9"
    sha256 arm64_monterey: "5bbe2e835b01cabedcc72bff006de1ef98a5d01460ac8dfaa78569df80f09d39"
    sha256 arm64_big_sur:  "e95369714002e785e6348856b98811a29660da71cfc68172d412750d9fb401a9"
    sha256 ventura:        "f86c5c767da1a932e95f8a8b93e72b2ac8f6415b9ceeb61841029e157994236e"
    sha256 monterey:       "a706bd336497f053137be73c5dfebdf4f092870a0231b6e6c63f6dfe2ebef0a0"
    sha256 big_sur:        "785a834a0e34bd10579434073a6e336117649a5ac6e1193ab50375b96b90904f"
    sha256 x86_64_linux:   "5b287e6d12ed222cbbc9ffe499cda3f0a2addd57f05cf4aead1a42e5eab311a6"
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
