class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "https://ftp.gnu.org/gnu/coreutils/coreutils-9.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/coreutils/coreutils-9.1.tar.xz"
  sha256 "61a1f410d78ba7e7f37a5a4f50e6d1320aca33375484a3255eddf17a38580423"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "ae9dc313da2a3971c8e633d9f3262fd1bd431c303207b3346924aed60bb0965d"
    sha256 arm64_monterey: "6a9a4988eda436fb5bdb5969044579c2e618e21eee8c8bbe32614ad29fe56bd7"
    sha256 arm64_big_sur:  "85ef910aa223d48c0e73fc187aba54b86930c86f906e3d079ed0b114762bb24e"
    sha256 ventura:        "4564009003601fb30335e57453cee93deaeab1eadf4473050e9e70198c21c892"
    sha256 monterey:       "7c9f988b4f9207415a5c96efd32376bc8cf2b280a7a36fbebb0b8fc334a14056"
    sha256 big_sur:        "e446ef889d70bc377d67fa2d7f6a1fbc9faaee444a9e9086a1f5bd484069e5c0"
    sha256 catalina:       "0d2117fa63dfcbb678c4e499f9ca0413c2c5bfa0a1bbdefde620434f2ead93a0"
    sha256 x86_64_linux:   "3c2fbec99344b50d620695d16197eb112cb8bee6d3f9e47cb682484755b91f38"
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
