class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.19.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.19.tar.gz"
  sha256 "4262136bdfc152b63ff5a9b93a7d80ce18b5e8bebdcffddc932dda769e306556"

  bottle do
    sha256 "cb6d07ccc60529a687f7e175c982ae065aa56a580bc13ba5a53949c058c072d7" => :catalina
    sha256 "ea90fe5d92832bd8491f3adcb5f01c67cd12eba112485f8e03b252909a019a68" => :mojave
    sha256 "43db4b67478cb35f0639fb616f4c4cf04c717a61dafe56c9d36adda921b90da0" => :high_sierra
    sha256 "5704a3d37c2790c482bbefc4290f3ffd589ab071e400f2e9610b267ea0f5a3dd" => :sierra
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-installed-readline
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gunits" => "units"
    (libexec/"gnubin").install_symlink bin/"gunits_cur" => "units_cur"
    (libexec/"gnuman/man1").install_symlink man1/"gunits.1" => "units.1"

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix "g".
      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
    assert_equal "* 18288", shell_output("#{opt_libexec}/gnubin/units '600 feet' 'cm' -1").strip
  end
end
