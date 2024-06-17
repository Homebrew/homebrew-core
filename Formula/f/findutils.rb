class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.10.0.tar.xz"
  sha256 "1387e0b67ff247d2abde998f90dfbf70c1491391a59ddfecb8ae698789f0a4f5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4632e8c4200947b4471dd14ccc7bb17a1d30c021c56de6061ca7ff5635cf1063"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02bab07606b4cc4489332e1a78f383abe4d6ed7afce997704eaf216ddda7f829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c36229f3cb487588e4278296c9f8a398a9cd272dd82e3a6d1bc86735a27b3e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "db0190807d6d1c0eae8fede9f5ecdc03621e7c29a386b97fcfdd0f9ed5e557ca"
    sha256 cellar: :any_skip_relocation, ventura:        "1fa79827c794159b52acb895f067c4f4b41fe6427707862c4103d33c50ac38a5"
    sha256 cellar: :any_skip_relocation, monterey:       "aca1fce6de56ec58b6d666bf2ee9dcb77d9a614762440fe18935a75d815613e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb6a963121bc5cbb06dc9d225f6019fc36059f0065412afe011d2a845960cf4"
  end

  def install
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
