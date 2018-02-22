class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.6.tar.xz"
  sha256 "d621e8bdd4b573918c8145f7ae61817d1be9deb4c8d2328a65cea8e11d783bd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd411d030058f27f1ce31cdb5d8a4c338195d43281fa477242100e43bc523e1e" => :high_sierra
    sha256 "e25b8b0c5e7cde495e36ab63e7e6d682dbe8039f0de292b85ce7f19b94ea1e41" => :sierra
    sha256 "b333804e8f86f2d99ac44c5cee06a3f615b8e69de0b68090792fd48436e8463a" => :el_capitan
    sha256 "e5c66fefaabbcbf9149128538bde4935be2bbc60849721c90546b21bca932399" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
    if build.without? "default-names"
      # Binaries not shadowing macOS utils symlinked without 'g' prefix
      noshadow = %w[cmp diff diff3 sdiff]
      noshadow.each do |cmd|
        bin.install_symlink "g#{cmd}" => cmd
        man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
      end

      # Symlink commands without 'g' prefix into libexec/gnubin and
      # man pages into libexec/gnuman
      bin.find.each do |path|
        next unless File.executable?(path) && !File.directory?(path)
        cmd = path.basename.to_s.sub(/^g/, "")
        (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
        (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
      end
    end
  end

  def caveats; <<~EOS
    All commands have been installed with the prefix 'g'.

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/gnuman:$MANPATH"

    EOS
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system "#{libexec}/gnubin/diff", "a", "b"
  end
end
