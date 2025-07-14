class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "81d22b34051621cd56c8d5ef12908ef2a59764c9cdfba6dae47aabddb71ac914"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "10ddde2d1f79d5af52f2efd790fa4a5bde8aa4d822c4bca874845abe3b7c0264"
    sha256 cellar: :any,                 arm64_sonoma:  "34068c161cdd3b13603881e7567b929c832dbdb17957f1f49ff5e26b0af4a4df"
    sha256 cellar: :any,                 arm64_ventura: "0aed6c8f284be50da5a5dcc5960871f503f7b275b02f3a855738dd67a23128e9"
    sha256 cellar: :any,                 sonoma:        "a7fa48b88a0c8527e4cbe4d79de1204e97a2657660109c69822d94bf52f3156e"
    sha256 cellar: :any,                 ventura:       "c3ede6d5e5911726971a35681b0852e26cdcd93799d7fbbda92b8ae73e9268d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d00e36c34fb56e1333ade4cab1801852db7b5416c709354ad26ecc9bb44f2316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b66f426a03a2fd27eca584c079b01e25b2cd23bb73f06cbc5fc3f187ddae90"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
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
