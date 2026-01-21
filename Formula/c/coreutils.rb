class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils/"
  url "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-9.9.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-9.9.tar.xz"
  sha256 "19bcb6ca867183c57d77155eae946c5eced88183143b45ca51ad7d26c628ca75"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "c1c98196cf47ba0693fcdfdc382baffe28f2898f566e93ef1b24b59ce30d1a8e"
    sha256 arm64_sequoia: "8c9f197f43acda73bf08c352730f37e49b4059622cfa6a45e1d71a1e018a92fd"
    sha256 arm64_sonoma:  "44051d68ba9de8afd8902900396d4726f447a08342f540c460f7472f18de1862"
    sha256 sonoma:        "d23bd4e530c024f868213201dfac8d0135c3e20d561065e3e0a55886c8cbdbb9"
    sha256 arm64_linux:   "8df4ae2018195ec710a08c196648f75a50728b9104acc6bdb00a5b81a2c1f93b"
    sha256 x86_64_linux:  "7f625a7b2b2eac3151a8d762b2f0458f97669746f077bf758d68490d546b0dc4"
  end

  head do
    url "https://git.savannah.gnu.org/git/coreutils.git", branch: "master"

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

  on_macos do
    conflicts_with "uutils-coreutils", because: "coreutils and uutils-coreutils install the same binaries"
  end

  on_sonoma :or_older do
    conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  end

  on_linux do
    depends_on "acl"
    depends_on "attr"
  end

  conflicts_with "b2sum", because: "both install `b2sum` binaries"
  conflicts_with "gfold", because: "both install `gfold` binaries"
  conflicts_with "idutils", because: "both install `gid` and `gid.1`"

  # https://github.com/Homebrew/homebrew-core/pull/36494
  def breaks_macos_users
    %w[dir dircolors vdir]
  end

  def install
    ENV.runtime_cpu_detection
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
      --with-libgmp
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
      (libexec/"gnuman/man1").install_symlink man1/"g#{cmd}" => cmd
    end
    (libexec/"gnubin").install_symlink "../gnuman" => "man"

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
