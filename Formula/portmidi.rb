class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0"
  license "MIT"
  version_scheme 1

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
  end

  def install
    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    if OS.mac?
      # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
      # "error: expected function body after function declarator" on 10.12
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

      system "make", "-f", "pm_mac/Makefile.osx"
      system "make", "-f", "pm_mac/Makefile.osx", "install"
      mv lib/shared_library("libportmidi"), lib/shared_library("libportmidi", version)
    else
      system "cmake", ".", *std_cmake_args, "-DCMAKE_CACHEFILE_DIR=#{buildpath}/build"
      system "make", "install"
      lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi", 0)
    end
    lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi")
    lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi", version.major.to_s)
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
