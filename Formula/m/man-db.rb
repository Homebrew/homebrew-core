class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.13.0.tar.xz", using: :homebrew_curl
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.13.0.tar.xz"
  sha256 "82f0739f4f61aab5eb937d234de3b014e777b5538a28cbd31433c45ae09aefb9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "27ba58e67a2b3deb04118225b9716dd8047a4c64f0969e631738cd322ddbc3c4"
    sha256 arm64_sonoma:   "2a8803f43ddac8a71bc3450156dde1ab02096cc43afc3e302bcba65eb7b6fc6c"
    sha256 arm64_ventura:  "ae98eff606a38947f0ad930f8e10cdf6005ae0a44fe1f020c595bf617a283679"
    sha256 arm64_monterey: "fb47b7738fc85725feedbdf2e51fe57e516da29d666f49b64f77f6738885a3d6"
    sha256 sonoma:         "1e89fce4c00002c61be615d8ed49dfb684f570697af3e1cea102eddf036fd71b"
    sha256 ventura:        "4b3a54a8dd4e2523c60f4b4074ea1fe2c635aa809038b9b1633a3640ac7e7278"
    sha256 monterey:       "113d700db2a88712b08beb40fec84fe89fe0c53b6c708cbfe69e45b0aec0fed0"
    sha256 x86_64_linux:   "e70f9a2750c93a8f2c88a7b843f73d063dd7fbe492d945a464b731a9289c4022"
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
      assert_match "General Commands Manual", output
      assert_match(/The true utility always returns with (an )?exit code (of )?zero/, output)
    else
      output = shell_output("#{bin}/gman gman")
      assert_match "gman - an interface to the system reference manuals", output
    end
  end
end
