class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "64893e823ae146cabd3ad7f9a9a9c5332746abe7847c557b99b2577afa8a607c"
  license "MIT"
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a02a8f130081aeda7fd82a826b510f4b2afdcf7af21cffe1d22963fcd3560065"
    sha256 cellar: :any,                 arm64_sonoma:   "c24a75dda06927ed08b718df274d6eae2f6f8ded0601673ccd4311a210f89681"
    sha256 cellar: :any,                 arm64_ventura:  "2d722c4357f6263f73456060dc5d131eb0b3b34ea54bef1cfe47d15bdc4ed75f"
    sha256 cellar: :any,                 arm64_monterey: "94415b613563629ea6425c629dc768e3c9319823870e948c4060742d24401588"
    sha256 cellar: :any,                 arm64_big_sur:  "f8ea203ccc085feee9e2e5c8f97ebcd59117f41331ac654dc542cfa8a901e2a9"
    sha256 cellar: :any,                 sonoma:         "ec2f3c4ed9b0fa14de06bf6802a8a111c7de434beaa0c3f082c99613cf12cc0f"
    sha256 cellar: :any,                 ventura:        "505796ff7499cb66673b8774af23109d1803cd0ca79e45de041d66985cb553e6"
    sha256 cellar: :any,                 monterey:       "7e348bdf4837001ff61ebad737ee19326a92c11ea2e122874abb39246a15b99e"
    sha256 cellar: :any,                 big_sur:        "3025725eb9196f45005ee6305883d78fb98fd6412569fdb2c3685e9f6f117009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af653a873aa1e1a5255269323d28c28b97c6860f52687dc4677020aa5bfbf7de"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  # Upstream patch, should be included in 2.0.5
  # Fixes the following CMake error:
  # The link interface of target "PortMidi::portmidi" contains:
  #  Threads::Threads
  # but the target was not found.
  patch do
    url "https://github.com/PortMidi/portmidi/commit/a47be8c58b25e2c122588e0b56306c0cfdce756c.patch?full_index=1"
    sha256 "aeeb22a3809fb79d370003936a6d5b110d33cfc88b39fc0f83d060e1b79dab4c"
  end

  def install
    if OS.mac? && MacOS.version <= :sierra
      # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
      # "error: expected function body after function declarator" on 10.12
      # Requires the CLT to be the active developer directory if Xcode is
      # installed
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
