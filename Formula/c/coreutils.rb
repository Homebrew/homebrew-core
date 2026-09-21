class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils/"
  url "https://ftpmirror.gnu.org/coreutils/coreutils-9.12.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-9.12.tar.xz"
  sha256 "a480198559733e9b3da999e90543ac6f888a2caa544d8d664c5a1f17e528e210"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "47f3076c16c02a734c142e52d16646bb76961353e7f9dc621b6e45215d916cb3"
    sha256 arm64_tahoe:       "df8e4e3dfb6ee737404df9e8dc78bb54d5eeb3c767241fca617fa5196c5747e2"
    sha256 arm64_sequoia:     "208a94fb7d6c2ebfb412fc127a6699d8ccb37e8492a940b843d1046db6a1e755"
    sha256 arm64_linux:       "d379b254313c151324d2220ef1009f5e7572eb7e39fac15ba9cc0a8b3e877687"
    sha256 x86_64_linux:      "2694642f5877654a15ef2277bdf7197b578368f9d505d45690a9dc06aec27616"
  end

  head do
    url "https://git.savannah.gnu.org/git/coreutils.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "wget" => :build
    depends_on "xz" => :build
  end

  depends_on "texinfo" => :build
  depends_on "gmp"
  uses_from_macos "gperf" => :build

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

  # GNU coreutils-9.12 added quoting to 'env' and 'printenv'. This has caused
  # some unforeseen issues in some invocations. Use a patch from upstream which
  # only quotes when standard output is not a terminal. See the following
  # mailing list discussion:
  # https://lists.gnu.org/archive/html/coreutils/2026-09/msg00061.html
  patch do
    url "https://github.com/coreutils/coreutils/commit/782a1e5bc2090212273bb731dceee2cc2a071e54.patch?full_index=1"
    sha256 "d93cf338341d9418522a637e3c99c4211a25a967d0cffd2f036fd18871f15e35"
    type :backport
  end

  deny_network_access!

  def install
    ENV.runtime_cpu_detection
    system "./bootstrap" if build.head?

    args = %w[
      --program-prefix=g
      --with-libgmp
      --without-selinux
    ]

    system "./configure", *args, *std_configure_args
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
