class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.32.tar.gz"
  sha256 "9b0d97b3d30df184d302bced12f976aa1e5fbf4b0be696cdebc6cca30411a46e"

  bottle do
    sha256 "68654c822c5e7c9bc53ae210a43a56c8710a2e313bfe0b5b7ff0f6ee315b6e21" => :catalina
    sha256 "ce0dcfa1e43603353f9961b4f0a4d7be8410311c0a26c94eeb5fb4b9300631f2" => :mojave
    sha256 "5f8b6709262fc2a62dec89d1b8b3c4f85ff1c20916e7c33a9be6b87205b6f285" => :high_sierra
    sha256 "a884754782026786a2f4b2a440110ba1da07c3ffa61849706277e2550b353e79" => :sierra
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--disable-werror",
                          "--target=arm-linux-gnueabihf",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
