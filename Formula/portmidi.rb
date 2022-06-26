class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0"
  license "MIT"
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d05c4cf7fd4598e7b06088c9207bbc35485f5e9dd631f21f6a0496232403a02"
    sha256 cellar: :any,                 arm64_big_sur:  "c3fd1fdcee43f0b1c8bc587b44b1e664bd9033e2849ba2e8127db21739020f13"
    sha256 cellar: :any,                 monterey:       "c3d70704721d80fc6cf532e36a21ef22a8237039d9e3467f97b72e282c85dfa5"
    sha256 cellar: :any,                 big_sur:        "3026d3f7d4640af9bc8a225841c94645580edde8a312910a56f707c436676e64"
    sha256 cellar: :any,                 catalina:       "e568b803867bc98754d383a7ff85adcdcb93df765b36f2e7e9dd8baecb71d49f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c405e50acde8be81e1505e686719f891ce35a5d9fc0b7917c407d739748e2eb5"
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

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
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
