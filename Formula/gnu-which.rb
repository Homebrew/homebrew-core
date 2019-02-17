class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/which/which-2.21.tar.gz"
  sha256 "f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "170008e80a4cc5f1e45b3445f9fb6f099d7700aa6dd825602f6d32316c27735b" => :mojave
    sha256 "66446416b0dc367076ab38cfc9775d8c201fc571b1a2cd2fc0197daa6b83882a" => :high_sierra
    sha256 "68ea3522ec318c9b25d711ce4405b4cd6a41edca20b7df008adc499ab794c4fa" => :sierra
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gwhich" => "which"
    (libexec/"gnuman/man1").install_symlink man1/"gwhich.1" => "which.1"

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats; <<~EOS
    GNU "which" has been installed as "gwhich".
    If you need to use it as "which", you can add a "gnubin" directory
    to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    system "#{bin}/gwhich", "gcc"
    system "#{opt_libexec}/gnubin/which", "gcc"
  end
end
