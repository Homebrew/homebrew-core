class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "f21201d4cc233638d7bb6ee29ee6dece54f6c9c1aeb7989bc978001caaf2f666"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02be979b495e1a9e201b22e8e136c97a5c81930e169c1aa38b83b46dd82f73e2"
    sha256 cellar: :any,                 arm64_sequoia: "68919e82b5dbbaf1150ab3f9c4b3d2a58a68836229ff1ae12a77319d020394fb"
    sha256 cellar: :any,                 arm64_sonoma:  "0cd908e5699f31817715fbb60cbe8840198f615620f556c384ad21bdf38120a6"
    sha256 cellar: :any,                 sonoma:        "8e95eab876a35c3d629c88ff159d05f0242083990586562a03f54bc9056f1be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "598ca599a4d47c9f106818c1593e52e26d7a512478d6fcee80dd26c6693d91c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66e2c410e774644f259314a481921b6ea633cc5fe7c610e2e703ce9b0ca572e"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lportmidi", "-o", "test"
    system "./test"
  end
end
