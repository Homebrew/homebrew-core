class ManDb < Formula
  desc "Unix documentation system"
  homepage "https://www.nongnu.org/man-db/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.10.2.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/man-db/man-db-2.10.2.tar.xz"
  sha256 "ee97954d492a13731903c9d0727b9b01e5089edbd695f0cdb58d405a5af5514d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/man-db/"
    regex(/href=.*?man-db[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fd876c39ea112c06c4f4d642530156d37dd2d631825bb1a658f043b1ef18c246"
    sha256 arm64_big_sur:  "aa63cd096bf541fbe8392bed8963a69de75376f9e77203ade0e242a162131866"
    sha256 monterey:       "cd1e73aca256a8ee637f76307e41d0e96c5b96df0a919af29e3a425bace347a5"
    sha256 big_sur:        "b907d3e2e2ce2367e62cf73c3a9aaaea5082c5f9bf6489f2e0ec9305ddcfcc95"
    sha256 catalina:       "c390e6f4182d8624926ba2624ec0caf62c21d1d5f901d0769ca1f8f87dba2757"
    sha256 x86_64_linux:   "147ba9c6070382aa4fce370e63ea03f8c49d66362f818c14d09bd7fb9e15b4a3"
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
