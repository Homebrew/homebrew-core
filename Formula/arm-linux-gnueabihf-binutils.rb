class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "59421be26e334cd713243e8470fc0a9407a9061042e2e47f592c7ad770ffb34e"
    sha256 arm64_monterey: "e7643d1794985d47e31b93873913a8ec7aa8fae723ddfc08e2ebdc0cee53dda7"
    sha256 arm64_big_sur:  "26a7485076f8532059c77f977386b2d829cedf1577961dcf89dd10418cdbeff6"
    sha256 ventura:        "dfdfb3a32104f5acb6062cfacbfef72a3e738aad63f87527676f4d631a3a4236"
    sha256 monterey:       "a5a3177b6827560cb5f0c3a18d16162d162b79c0d9cd829d47d42bc9d406f2ca"
    sha256 big_sur:        "88514862e122a26ca11dc9f2f21d53883f2150d89d583c6c046b29569d0e855c"
    sha256 catalina:       "6f8cbd94bf5ba89b49b3547ab29b90e9bcf4b2d6ca2173a88b80751e44160491"
    sha256 x86_64_linux:   "630a97002e764c3f2a9df69ee344e31ad9ea897da540d0dd5fef97b96ac269a1"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "arm-linux-gnueabihf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
