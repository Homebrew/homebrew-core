class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftp.gnu.org/gnu/time/time-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/time/time-1.9.tar.gz"
  sha256 "fbacf0c81e62429df3e33bda4cee38756604f18e01d977338e23306a3e3b521e"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "dc007b95e2f9fb0df3380da55d3c9337529b1a4a3cd762972eb88512f567ea1c" => :mojave
    sha256 "ad5d776c38e43f16fad8976770eeaa18e40562c166fa65fdaa12af61981c7b90" => :high_sierra
    sha256 "d51ef948a5a87281175fef771cb28469cbdb3085e3c51ad325d780ff921cc013" => :sierra
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --info=#{info}
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gtime" => "time"
  end

  def caveats; <<~EOS
    GNU "time" has been installed as "gtime".
    If you need to use it as "time", you can add a "gnubin" directory
    to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    system bin/"gtime", "ruby", "--version"
    system opt_libexec/"gnubin/time", "ruby", "--version"
  end
end
