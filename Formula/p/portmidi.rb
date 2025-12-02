class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "43fa65b4ed7ebaa68b0028a538ba8b2ca4dc9b86a7e22ec48842070e010f823f"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78a7e46df8019297d38f47a4e0b1d1338a842473ce818348681b39379a0b8e03"
    sha256 cellar: :any,                 arm64_sequoia: "47b659e50f8ab01b1c1606c81bd25e927f3757ae84bf0b3c77f9e93bcbd74f3f"
    sha256 cellar: :any,                 arm64_sonoma:  "a8c3ea6a6efd6be8d4d9ddb63bea9415e606476bcae0ea9d1646078b972e831d"
    sha256 cellar: :any,                 sonoma:        "1e1ce71bf25b00b29b4b0d6963f1fac0ecd95228f47a675ee04488342df3b398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b276ff1f2f820e52e2b66165f2ac97889c9a71c9c5654f302e6a49ea717275c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67a6ae4b4f17947cf80aa1de8b90590ca76647b946817dbf601e472212eaa83"
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
