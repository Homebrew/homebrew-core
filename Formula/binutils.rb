class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.31.1.tar.gz"
  sha256 "e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88"
  revision 1

  bottle do
    sha256 "92fdc2c6b6b95c3944156ad3da3b5c8a3118c245e088712df451237de67d6732" => :mojave
    sha256 "a3ed5e2bf0cd0823c5140a6bf44d13f32fbc63a67a4e6d239e1c391518432bd7" => :high_sierra
    sha256 "a815d5c60302a1e71c0970d86769931abd5e985f8d420cfd527aa495930cd393" => :sierra
    sha256 "7c693e68ebfcd654fd781480e68469e8f5af93c7397754a8caae1937322feb8f" => :el_capitan
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
