class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/which/which-2.21.tar.gz"
  sha256 "f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "83fb2814c1a81fa381f5462565141ff1f4fd0580847288c7047019353bad0fa4" => :mojave
    sha256 "1c2174cbc0d721dec7f86f920dbdda09109c84fdf8b8cada6a10b01d496e411b" => :high_sierra
    sha256 "ebd500ad7b851205dd25c7ec78441f029b9982b8a0f3df081266e58f6df7c6ec" => :sierra
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
