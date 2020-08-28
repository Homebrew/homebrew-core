class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.1.0.tar.xz"
  sha256 "cf5fea4ac5665fd5171af4716baab2effc76306a9572988d5ba1078f196382bd"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "581b48f781104f0c3233edc30c47628f4eec8c2f1f2e191151f367ce26ec538a" => :catalina
    sha256 "ddbb56c56d66f375147769a27301e2ffd099abdc07f5dfc16389af22028e185b" => :mojave
    sha256 "eac1b8c97c682c32a1b6c589818aa8ffb8f09630258ed6f215c882368540713e" => :high_sierra
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  conflicts_with "awk",
    because: "both install an `awk` executable"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix",
                          "gl_cv_func_ftello_works=yes" # Work around a gnulib issue with macOS Catalina

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
