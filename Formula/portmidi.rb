class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8ec4a3364a27fc26ca308b668cc16a487833110ebc2bc18414c4f21465f15b65"
    sha256 cellar: :any,                 arm64_big_sur:  "100d2ff0ac315d597f7aa5b33262d18a0323e63a8bd4f370953396946cf7c038"
    sha256 cellar: :any,                 monterey:       "87e050e43e85e7f7a3da7df96fe5ce56a76ce175e25869318b298d7dc310fdb1"
    sha256 cellar: :any,                 big_sur:        "e97ac2b923ac89752aa3d4eaa9d9bd68335248575cf1b94387c896c1e9b6f788"
    sha256 cellar: :any,                 catalina:       "b0bad0f22a7eb7933950aad6d684d5a382921ea43687bd662a054d60f8b12aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "179bf2d45bb53a20c90906acac509e723cefe2ffe078a500456ff000fd1609b7"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath
    (lib/"pkgconfig").mkpath

    if OS.mac?
      # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
      # "error: expected function body after function declarator" on 10.12
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

      system "make", "-f", "pm_mac/Makefile.osx"
      system "make", "-f", "pm_mac/Makefile.osx", "install"
      mv lib/shared_library("libportmidi"), lib/shared_library("libportmidi", version)
      # awaiting https://github.com/PortMidi/portmidi/issues/24
      (lib/"pkgconfig").install "Release/packaging/portmidi.pc"
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
