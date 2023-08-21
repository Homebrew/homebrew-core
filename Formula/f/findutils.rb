class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.9.0.tar.xz"
  sha256 "a2bfb8c09d436770edc59f50fa483e785b161a3b7b9d547573cb08065fd462fe"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74fbe230e7727aaaf128082d47a2fc0f032c204154375b83461161442934961a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e21f10bcc0baed90d33aad5ce7428f9ad24a9cd4e35f4b0003e14160045f8fb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72ddcf7cfdccb52f6c4c4f20c2c0cdbb4111d37641d73a1622a4af170ed5b53b"
    sha256 cellar: :any_skip_relocation, ventura:        "c32f96d54d0b689a5df3f9664a65d2a1fe954402481a49593767b5e856700887"
    sha256 cellar: :any_skip_relocation, monterey:       "595025aa645a0bc036179b30613986bd436081cc4416db21de0f8fba4d95934b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2171d40184a93549ca6877410abf8717c7d8b13ae1a0bf3568dd49a24b7747e"
    sha256 cellar: :any_skip_relocation, catalina:       "a957b1c3b354edee634d1d96f66315fa8ea327efc9f282c8c026b5298d8802e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be871b90f426c6a6b9f292e65ba359c402017e783523746e965d849436137db"
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
