class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils/"
  url "https://ftpmirror.gnu.org/coreutils/coreutils-9.12.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-9.12.tar.xz"
  sha256 "a480198559733e9b3da999e90543ac6f888a2caa544d8d664c5a1f17e528e210"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "3230dfda5ec735db8f69a113518a68f8f375f929178cab7c69f618c2606aae9d"
    sha256 arm64_tahoe:       "38e01cd05410c44aa21fac5ae1700164771cd2028a9e1506f07a743b53a7b73d"
    sha256 arm64_sequoia:     "c845a8ad8933ec45614e331e4f861862a4766a716ea7c13ee102e50a056c7792"
    sha256 arm64_linux:       "51e6c759ba3872c59a82610c429bfa343926c48e7f4296bb6a1a23b863545ea2"
    sha256 x86_64_linux:      "4a261303ec2ac867e77e32b156306fb9f27781a4a5cce754d4e9f249882a00db"
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

  on_macos do
    depends_on "openssl@4"
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

    if OS.mac?
      ENV.append "CPPFLAGS", "-I#{formula_opt_include("openssl@4")}"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("openssl@4")}"
    end

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
