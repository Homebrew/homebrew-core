class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.7.tar.xz"
  sha256 "2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "fd4d42fd7c2896ec25477cf132ee944e0977fe3f3fc98125e5319bf524a84024" => :catalina
    sha256 "568caa32e2f48a1a3a0363e33367effbf447064eca64f471076c3dace6a4eae0" => :mojave
    sha256 "c633ae024f6c977abee048485ac37a321ed7badcaab2377c5e1082f68210d28b" => :high_sierra
  end

  conflicts_with "ssed", :because => "both install share/info/sed.info"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --program-prefix=g
    ]

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

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
