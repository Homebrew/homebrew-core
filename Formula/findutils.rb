class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.7.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.7.0.tar.xz"
  sha256 "c5fefbdf9858f7e4feb86f036e1247a54c79fc2d8e4b7064d5aaa1f47dfa789a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9ba06f4d48275e8cab659450b05e77873e909f31104df450201a83d465ed1ca" => :catalina
    sha256 "3c609b729a1dc859459282a856ff6c164cd8388e531dad4e58c8d4c7acb670fb" => :mojave
    sha256 "996a9fe2b1829fdf7b7257bead0ef0c4315832e9ba21b149779abeb59dcbde30" => :high_sierra
    sha256 "4b66ce398f2d5f5c65bf0b05fcc55334398e75cb965a17d781d7c3a15a4bba61" => :sierra
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}/locate
      --disable-dependency-tracking
      --disable-debug
      --program-prefix=g
    ]

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    system "./configure", *args
    system "make", "install"

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

    libexec.install_symlink "gnuman" => "man"
  end

  def post_install
    (var/"locate").mkpath
  end

  def caveats; <<~EOS
    All commands have been installed with the prefix "g".
    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:
      PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/gfind .")
    assert_match "HOMEBREW", shell_output("#{opt_libexec}/gnubin/find .")
  end
end
