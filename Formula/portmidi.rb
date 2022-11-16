class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "64893e823ae146cabd3ad7f9a9a9c5332746abe7847c557b99b2577afa8a607c"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d1eacabbed9b9cc21f5891126b95474c410072736d1e0f0c69c85a1d05ee863"
    sha256 cellar: :any,                 arm64_monterey: "e72738db9423088d59d65c5d41a41c17a6a929c286122c53dc8377ba48bae523"
    sha256 cellar: :any,                 arm64_big_sur:  "6ef793d31a216d3ab6326ca7342c8a18b7e9e1432386421cf9a3a6a675bf4e02"
    sha256 cellar: :any,                 ventura:        "fd8e93c75f7a823b4e592dfa7f951e6a4f2c2536c8262ae443e1de073d19c9e5"
    sha256 cellar: :any,                 monterey:       "62fbb028d9eeb83d047559f0f7f6a7c23d586340f8314135cc369ca08e276a7c"
    sha256 cellar: :any,                 big_sur:        "b69592ca4c66139bf269b33d45caede69a883f2e99bc8e6cca6d8db91c71df49"
    sha256 cellar: :any,                 catalina:       "2b9d9436b11340384d5f447d05e765d48dbd9a3e38edff58d49193d1a4ba097f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb867e2067ab2610c4970281f93a7c21109f1cacd699cf66d965c4a87fe6a50"
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
