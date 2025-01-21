class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.10.0.tar.xz"
  sha256 "1387e0b67ff247d2abde998f90dfbf70c1491391a59ddfecb8ae698789f0a4f5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c09536c5626e7159ccbee77d9a8c771397305bdaecd8a9a67c495482c8dba0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c9fb06c4b3b4bdd0cf9dd38b18168a2ec9bfd689af59ef95808246c4b7c3c91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f8cb6a602454e6739de9b20f925692c192d33d9d3b725447be3e9eee9ebd13f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a95af4320383b2e5b00f76fa5b17dc904cc5f1599536fc316f79000c6d85483d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f6c220a82a470cd41bd33c330d6bb752df6da9df4aa2ead4e011fff80abad0c"
    sha256 cellar: :any_skip_relocation, ventura:        "90ec3d5bf4c1f5c58bad4e40a28f00f856e5f15f995a2e724b89a882112e4db2"
    sha256 cellar: :any_skip_relocation, monterey:       "642fe05dc9e71c9941570328bf7f8ab9d5c61e5517211ab8f62a08f9d3936ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2d353feb5ebd258d6a53a4ca3c5904dec97797c56bbd13ae5ff75cdebc0492"
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

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
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
