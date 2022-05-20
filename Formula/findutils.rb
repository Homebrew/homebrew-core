class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.9.0.tar.xz"
  sha256 "a2bfb8c09d436770edc59f50fa483e785b161a3b7b9d547573cb08065fd462fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b223ecf4ba6f6e2cc114c7d5c5d1f906e884f8d441251198e4f64a47d42e5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "960d4e30e7a46e645fae74dd61f1e4bcd4b4ef4ed9a71932185009a35656d17b"
    sha256 cellar: :any_skip_relocation, monterey:       "71c2f8a1a5ba6ee4a6a0997941f0ef07b7d929e2b5a436a18401713f8876a075"
    sha256 cellar: :any_skip_relocation, big_sur:        "53233d604a2883a2ba80b9fc908a319be843d66f50ed2ab27fbf32570e2731ad"
    sha256 cellar: :any_skip_relocation, catalina:       "172e582f81d194e139eae1f5571b0e885ca8eab0374a96b2f85fdd26e4a8d33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cfc6ac5f8e8e636b69fcf4a6117090f77caf4fea4b1b749da05722421569618"
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    # Workaround for build failures in 4.8.0
    # https://lists.gnu.org/archive/html/bug-findutils/2021-01/msg00050.html
    # https://lists.gnu.org/archive/html/bug-findutils/2021-01/msg00051.html
    ENV.append "CFLAGS", "-D__nonnull\\(params\\)="

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}/locate
      --disable-dependency-tracking
      --disable-debug
      --disable-nls
      --with-packager=Homebrew
      --with-packager-bug-reports=#{tap.issues_url}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      [[prefix, bin], [share, man/"*"]].each do |base, path|
        Dir[path/"g*"].each do |p|
          f = Pathname.new(p)
          gnupath = "gnu" + f.relative_path_from(base).dirname
          (libexec/gnupath).install_symlink f => f.basename.sub(/^g/, "")
        end
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def post_install
    (var/"locate").mkpath
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    touch "HOMEBREW"
    if OS.mac?
      assert_match "HOMEBREW", shell_output("#{bin}/gfind .")
      assert_match "HOMEBREW", shell_output("#{opt_libexec}/gnubin/find .")
    else
      assert_match "HOMEBREW", shell_output("#{bin}/find .")
    end
  end
end
