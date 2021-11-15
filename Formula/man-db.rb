class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.9.4.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.9.4.tar.xz"
  sha256 "b66c99edfad16ad928c889f87cf76380263c1609323c280b3a9e6963fdb16756"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9e5302cdc6d452943921cfefe681adc2db9a92e47bf92cdb0e96eaacf9c96ca9"
    sha256 arm64_big_sur:  "6a96017a3bbef997608f6f6fd6e03e5106ae99c5058566be8e7115e4966f6641"
    sha256 monterey:       "07f37a992a0445614097bded19707c6742fd969a8fdd621fe30ddfd88cf23da1"
    sha256 big_sur:        "4529e4902e85caf37876458918ce7eac6513f28d4893834da88b1b772b3f22a9"
    sha256 catalina:       "297439323c747e9fcfc6f27aca5c465affe33a614685cd4d90b32901d4a9a61f"
    sha256 mojave:         "727b00709a5bde708f039abd8bcad7f861b4815301a5773d1fabc79fbeac2645"
    sha256 x86_64_linux:   "000fbacc5696988c5c467eae8cc378aad1cb1bce92386e2c3ed30956f59da65e"
  end

  depends_on "pkg-config" => :build
  depends_on "groff"
  depends_on "libpipeline"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gdbm"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-cache-owner
      --disable-setuid
      --disable-nls
      --program-prefix=g
      --with-config-file=#{etc}/man_db.conf
      --with-systemdtmpfilesdir=#{etc}/tmpfiles.d
      --with-systemdsystemunitdir=#{etc}/systemd/system
    ]

    system "./configure", *args

    system "make", "install"

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
    output = shell_output("#{bin}/gman true")
    on_macos do
      assert_match "BSD General Commands Manual", output
      assert_match "The true utility always returns with exit code zero", output
    end
    on_linux do
      assert_match "true - do nothing, successfully", output
      assert_match "GNU coreutils online help: <http://www.gnu.org/software/coreutils/", output
    end
  end
end
