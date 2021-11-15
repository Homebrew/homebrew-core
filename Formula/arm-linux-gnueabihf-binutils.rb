class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
  sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "ce85c9e96511b8da8c5c3f06044b496bf1fe1b267c9e4a00eaa12c0c75e2cf55"
    sha256 arm64_big_sur:  "f090259411ea17662b23b08700cc6bb63116624932ef17388e80cb88ec431fa5"
    sha256 monterey:       "f536d989370b32b15fb0d55026dc4f6722fd30b4e89ec918a3ae18f772a2fda9"
    sha256 big_sur:        "6fae8a0bdc7ef15c1f6dcfac0ae2a8bd533f0e5cbbdb44e857f48c5412b90a0c"
    sha256 catalina:       "1ab534b59889553b9880a283d78800e5a334e3b883d896879f2f2a8d0f2e9531"
    sha256 mojave:         "3d2a120a2968b69da655591646fe673023631e237e197c00e8e6301bcc1a6dad"
    sha256 x86_64_linux:   "8d75311051fcd313c68ff04c1bdef32d740177f259dad09dc4fdea83584e706b"
  end

  uses_from_macos "texinfo"

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
