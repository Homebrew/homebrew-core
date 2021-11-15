class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.8.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.8.0.tar.xz"
  sha256 "57127b7e97d91282c6ace556378d5455a9509898297e46e10443016ea1387164"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e0cb2db77a4b293dac21671faa9b3ffc853ceb60319ad49824921320b6bcdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00515eb2dc81769263cbde9066c25807b120e3a25a7dbff3f5a3858c07ba7f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf672398a53cc57cfee7b0606076f869bc8f13004e691d951f3460e167379a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba06afcd59371297f232da8d59a68ebc2d66ce3ffdad3e83f65e2e9abb47a4c0"
    sha256 cellar: :any_skip_relocation, catalina:       "7e47d6ae1e52d796ce0fd989c17ac169f1b78206e62a28274fe25296185a8a66"
    sha256 cellar: :any_skip_relocation, mojave:         "78cf4e5b65633636743fd29b7fd3b48aebd20bed727203dc244192fdfa543f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bcba0a1078da1c7c44ca826928def5e3429df58ecc854b3a156896118576575"
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
    on_macos do
      assert_match "HOMEBREW", shell_output("#{bin}/gfind .")
      assert_match "HOMEBREW", shell_output("#{opt_libexec}/gnubin/find .")
    end
    on_linux do
      assert_match "HOMEBREW", shell_output("#{bin}/find .")
    end
  end
end
