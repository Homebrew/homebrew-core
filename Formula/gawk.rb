class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-4.2.1.tar.xz"
  sha256 "d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"
  revision 1

  bottle do
    rebuild 1
    sha256 "7c75090bc176f309855c5eaf4a7b11c184b7619971fa9cff88272cd79952ab7d" => :mojave
    sha256 "f1c8e8d852bfd156056b3dea4b80704b707adfd742795ccfd47ca33e5ab9a1dd" => :high_sierra
    sha256 "ca8c762e95dcd6733fd49d20be8733cf179d4b3c4e0ec9bc9ffb3c54cfdea9c0" => :sierra
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make", "check"
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
