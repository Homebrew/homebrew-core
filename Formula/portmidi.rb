class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0"
  license "MIT"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "9f36b2b3dfcc7e4ef4e8770b4fbf65ef56153c74d9e59f5ad8c4d575ea150aed"
    sha256 cellar: :any,                 arm64_big_sur:  "9d427fa7b46931a71ab8d0b4c4439860cfe10dc58aeac76716687e8592809df9"
    sha256 cellar: :any,                 monterey:       "d71bf72668045657cf5bde48294205957ee4a01f5ba2165183b13a8608a1211b"
    sha256 cellar: :any,                 big_sur:        "5de1c249c9bb53e5a5481c9dcbd7817108b51a7f3803067b49d7a76cb6c0cb0b"
    sha256 cellar: :any,                 catalina:       "f8e118bd15493c94e49b6c8e8c7e1c8368e42b34d9c442d08dcd6d8361e517d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52b02493f0f5566f3c37278c10db9c0bdecd3324193aaeaa2fcff7b04a2f03ef"
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
