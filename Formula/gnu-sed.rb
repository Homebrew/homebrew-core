class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.7.tar.xz"
  sha256 "2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a1d45377723857fe063e64d19023cce633c8abd2a40b96e1331ebac93d07e08f" => :mojave
    sha256 "9a8f2e31cb6ab729429ba4bf5c7fb0f9333cda7a78d7e6f052cf3534ab4cbddc" => :high_sierra
    sha256 "2f5d798d3157939f1c2edab1fb1f519018fc8eb78181d9f669df68197c517b45" => :sierra
  end

  conflicts_with "ssed", :because => "both install share/info/sed.info"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
    (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats; <<~EOS
    GNU "sed" has been installed as "gsed".
    If you need to use it as "sed", you can add a "gnubin" directory
    to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    (testpath/"test.txt").write "Hello world!"
    system "#{bin}/gsed", "-i", "s/world/World/g", "test.txt"
    assert_match /Hello World!/, File.read("test.txt")

    system "#{opt_libexec}/gnubin/sed", "-i", "s/world/World/g", "test.txt"
    assert_match /Hello World!/, File.read("test.txt")
  end
end
