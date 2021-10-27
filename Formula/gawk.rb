class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.1.0.tar.xz"
  sha256 "cf5fea4ac5665fd5171af4716baab2effc76306a9572988d5ba1078f196382bd"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "c7e90692c90e792c6dcc57238f19c5a5445b8eeb58327a8e9750be1fd4e07f8f"
    sha256 arm64_big_sur:  "086699256ed712a766460a9eabd458c811f143d4f4838e8b4dc8111393c6c1a7"
    sha256 monterey:       "b2f924db4e84338bd6936257d9ba22e968b3668e553eace5a81728664f3fb749"
    sha256 big_sur:        "11c0efd1978398ce9f0f6054568cdb3dd6a118850e0ba5fd58ab22cc711bb24d"
    sha256 catalina:       "cf6b5162414fcfa16b5e22085f54f5d6b228989ef3ddd921f7b25a50af1ed337"
    sha256 x86_64_linux:   "b4db49bad5b993307c547e4dd12bc5a7cfca71477bdf91b28224de873cbdc251"
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
                          "--without-libsigsegv-prefix"

    system "make"
    if which "cmp"
      system "make", "check"
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    libexec.install_symlink "gnuman" => "man"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
