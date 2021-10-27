class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "https://ftp.gnu.org/gnu/coreutils/coreutils-9.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/coreutils/coreutils-9.0.tar.xz"
  sha256 "ce30acdf4a41bc5bb30dd955e9eaa75fa216b4e3deb08889ed32433c7b3b97ce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "9a72c1fef593eef2757398be776c656885def021d5e276be11ab26174bfe5d91"
    sha256 arm64_big_sur:  "875e9ec351a0624e65d19e742a7271fc409ce912fa4a4ad9147ab21eaa126bad"
    sha256 monterey:       "e59c6a7cd6993b3d61dfa133b4091f731220d10ed7c23f8808870a22bc3ad8a7"
    sha256 big_sur:        "6c6b84b32d923e26b1c67e8c9aee801f7ab2f0b9f94d9b455b784eb3a2dc575c"
    sha256 catalina:       "9b24df176ef9ec342e83af6880c27e0235e4fcc436d0143fb37eb24695de51a6"
    sha256 mojave:         "6755e3bb94c35dae4ebbd525633691bc5ff1dc82a84f5b968b952d7be86652d7"
    sha256 x86_64_linux:   "6ab4d61127fac0e193a82881b9262e3121ada87566f470abdf6a2b9c63ab6768"
  end

  head do
    url "https://git.savannah.gnu.org/git/coreutils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build
    depends_on "xz" => :build
  end

  depends_on "gmp"
  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "attr"
  end

  conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  conflicts_with "b2sum", because: "both install `b2sum` binaries"
  conflicts_with "ganglia", because: "both install `gstat` binaries"
  conflicts_with "gdu", because: "both install `gdu` binaries"
  conflicts_with "gegl", because: "both install `gcut` binaries"
  conflicts_with "idutils", because: "both install `gid` and `gid.1`"
  conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  conflicts_with "truncate", because: "both install `truncate` binaries"
  conflicts_with "uutils-coreutils", because: "coreutils and uutils-coreutils install the same binaries"

  # https://github.com/Homebrew/homebrew-core/pull/36494
  def breaks_macos_users
    %w[dir dircolors vdir]
  end

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
      --with-gmp
      --without-selinux
    ]

    system "./configure", *args
    system "make", "install"

    no_conflict = if OS.mac?
      []
    else
      %w[
        b2sum base32 basenc chcon dir dircolors factor hostid md5sum nproc numfmt pinky ptx realpath runcon
        sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf stdbuf tac timeout truncate vdir
      ]
    end

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd

      # Find non-conflicting commands on macOS
      which_cmd = which(cmd)
      no_conflict << cmd if OS.mac? && (which_cmd.nil? || !which_cmd.to_s.start_with?(%r{(/usr)?/s?bin}))
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
    libexec.install_symlink "gnuman" => "man"

    no_conflict -= breaks_macos_users if OS.mac?
    # Symlink non-conflicting binaries
    no_conflict.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats
    msg = "Commands also provided by macOS and the commands #{breaks_macos_users.join(", ")}"
    on_linux do
      msg = "All commands"
    end
    <<~EOS
      #{msg} have been installed with the prefix "g".
      If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"gsha1sum", "-c", "test.sha1"
    system bin/"gln", "-f", "test", "test.sha1"
  end
end
