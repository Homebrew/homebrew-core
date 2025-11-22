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
    sha256 arm64_tahoe:   "3b4ff986ec8efa0309117b956361b967a7d0d62bcd3489ddc6e1f50424264883"
    sha256 arm64_sequoia: "814476e3056aff5c88da27acca3153f44e60cd64ec964689998728ec86f074bf"
    sha256 arm64_sonoma:  "4cdc0506f77895a91bbd2bb3e66841a00ac8fe05826eff469e63e8f73a89cacb"
    sha256 arm64_ventura: "80dccecdde51608a0007a5b55a68ad152d9df01edb4d20943bdee1d25d59cf07"
    sha256 sonoma:        "f6c8b05ccbaf7c5834bd1aa3d30b55d5e51d6de8864e829555c060823e09aaea"
    sha256 ventura:       "da8b0c64287f926108f16d8d41e037af06f01f26778fabf25c531f7aa872e58d"
    sha256 arm64_linux:   "6bc4fa308acf12f0365268ade917e6dc496b0d75b8a4ffc5ebc80bcfcfb0fd29"
    sha256 x86_64_linux:  "d337092513af299c568743a128b5ab5aad480e9c42b122cec9f507b00938809f"
  end

  depends_on "pkgconf" => :build
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
