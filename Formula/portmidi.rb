class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/portmidi-src[._-]v?(\d+(?:\.\d+)*)\.}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "22d94369f7d0908f12fb4152ff61c4fda25ec13a2d27a2a7a877f578091b66d7"
    sha256 cellar: :any,                 arm64_big_sur:  "3b88c9a63729019e630cd581fd6f54141cba80e6c0c2f57c369e67cd1b2e524b"
    sha256 cellar: :any,                 monterey:       "475293c8e6adf7796aaa7c0a5d8ed2be72b772db607ed2e51e33efef3ea4463d"
    sha256 cellar: :any,                 big_sur:        "b1f389b0e897e7fe5864bab75a9568bb4f08ede002f96f737f53248b88d49b43"
    sha256 cellar: :any,                 catalina:       "d36a5abe7624c563740d43403605a26d4c697ea4ed917f0263bc2869f1f9a766"
    sha256 cellar: :any,                 mojave:         "79c16a1e0a063781b5d89162d9c04e9bc6ff01a46a61479ea196d6749f0d0aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6020495625938e80fe6242050f0aec05cf0061ebc77b009fb0806c3239952471"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"

    # Fix hardcoded "/usr/local" paths to install libraries and headers
    patch do
      url "https://sources.debian.org/data/main/p/portmidi/1:217-6/debian/patches/00_cmake.diff"
      sha256 "9a73c4453e784f97927d4412a916814b6f2ed864bd5f49d383c6650b8590fd26"
    end

    # Fix build error: midithru.c:(.text+0x374): undefined reference to `Pt_Start'
    patch do
      url "https://sources.debian.org/data/main/p/portmidi/1:217-6/debian/patches/20-movetest.diff"
      sha256 "938560fc3a6910f9451b11136ab295b68d8b0e0539a3cd0f02550d209bb39202"
    end

    # Install porttime libraries
    patch do
      url "https://sources.debian.org/data/main/p/portmidi/1:217-6/debian/patches/30-porttime_cmake.diff"
      sha256 "e6d26bfd2018e90d68c86cf5c7275480111873487d202bed7b1717a38dfa0fe2"
    end
  end

  # Do not build pmjni.
  patch do
    url "https://sources.debian.org/data/main/p/portmidi/1:217-6/debian/patches/13-disablejni.patch"
    sha256 "c11ce1e8fe620d5eb850a9f1ca56506f708e37d4390f1e7edb165544f717749e"
  end

  def install
    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    if OS.mac?
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

      # Fix outdated SYSROOT to avoid:
      # No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/...'
      inreplace "pm_common/CMakeLists.txt",
                "set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE",
                "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

      system "make", "-f", "pm_mac/Makefile.osx"
      system "make", "-f", "pm_mac/Makefile.osx", "install"
    else
      system "cmake", ".", *std_cmake_args, "-DCMAKE_CACHEFILE_DIR=#{buildpath}/build"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <portmidi.h>

      int main()
      {
        int count = -1;
        count = Pm_CountDevices();
        if(count >= 0)
            return 0;
        else
            return 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lportmidi", "-o", "test"
    system "./test"
  end
end
