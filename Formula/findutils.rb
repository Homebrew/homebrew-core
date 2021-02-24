class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.8.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.8.0.tar.xz"
  sha256 "57127b7e97d91282c6ace556378d5455a9509898297e46e10443016ea1387164"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39ffd40141c1d583f89ffe0c091a76cba9f4ebdbe3035c007e45b37774eb5b84"
    sha256 cellar: :any_skip_relocation, big_sur:       "4841d8c66138b3f5eb7d6a3c1588ae19e69c4a2561f6a6e2192a51e324022093"
    sha256 cellar: :any_skip_relocation, catalina:      "86d61877d4c20e5bf2f89939034b0a058526c7f614d454c602fdd5685021f058"
    sha256 cellar: :any_skip_relocation, mojave:        "34bffcfa0d3924fdc7140ba766615ef66ccd5a0336ce779ff062b66b6f60af3e"
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

    on_macos do
      args << "--program-prefix=g"
    end
    system "./configure", *args
    system "make", "install"

    on_macos do
      # https://savannah.gnu.org/bugs/index.php?46846
      # https://github.com/Homebrew/homebrew/issues/47791
      (libexec/"bin").install bin/"gupdatedb"
      (bin/"gupdatedb").write <<~EOS
        #!/bin/sh
        export LC_ALL='C'
        exec "#{libexec}/bin/gupdatedb" "$@"
      EOS

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
    <<~EOS
      All commands have been installed with the prefix "g".
      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
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
