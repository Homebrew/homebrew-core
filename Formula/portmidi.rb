class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "66b8773aa12201f7fa2bf44044ab32bdab1cdf763db870fde3f0bd7254c5d877" => :catalina
    sha256 "2a6258da2f83b668c2ba85edd9e49313114af5bfb288ebc681bd4cde221279c6" => :mojave
    sha256 "61f9a94aaca3f317c50e643b06617804d37798e32dd1cfcc1c24aecdc24aec75" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra || MacOS.version == :el_capitan

    inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    # Fix outdated SYSROOT to avoid:
    # No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/...'
    inreplace "pm_common/CMakeLists.txt",
              "set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE",
              "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

    system "make", "-f", "pm_mac/Makefile.osx"
    system "make", "-f", "pm_mac/Makefile.osx", "install"
  end
end
