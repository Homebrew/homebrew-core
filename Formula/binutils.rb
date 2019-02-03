class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.32.tar.gz"
  sha256 "9b0d97b3d30df184d302bced12f976aa1e5fbf4b0be696cdebc6cca30411a46e"

  bottle do
    sha256 "dbe26381158b6fe4c597761babd3e3057353f59fa1b20cd73842f651d02f37da" => :mojave
    sha256 "fe41922c19581745c04cec1d4d91332111a18c5a160852478d301f6735753a2a" => :high_sierra
    sha256 "983abea2ac000ceb1deb4a87088ffbada2f6047d904aa16c9ad2e56f3a363516" => :sierra
  end

  keg_only :provided_by_macos,
           "because Apple provides the same tools and binutils is poorly supported on macOS"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    Dir["#{bin}/*"].each do |f|
      bin.install_symlink f => "g" + File.basename(f)
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
