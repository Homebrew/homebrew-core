class Librtlsdr < Formula
  desc "Use Realtek DVB-T dongles as a cheap SDR"
  homepage "https://osmocom.org/projects/rtl-sdr/wiki"
  url "https://github.com/steve-m/librtlsdr/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "e108d3c6a00efcdf55877d1172be538842686c50377043319baffcfdb6b7b9cb"
  license "GPL-2.0-or-later"
  head "https://git.osmocom.org/rtl-sdr", using: :git, branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a3b78465f00d9d2f15ac7f3cee89fec6a3d7fac334781e72184f49d6eee8d87"
    sha256 cellar: :any,                 arm64_ventura:  "16640fb81caea9e2110ceadf627eeae6e1c297e61908a4be8c76987d84c67a68"
    sha256 cellar: :any,                 arm64_monterey: "a8ac7833c7b1860eed341892fd2c8a3ff8008b4138ad0589f745ccd9dd96eb6e"
    sha256 cellar: :any,                 sonoma:         "ff6d7a362587493ac69717ececa8ba87021c51508139c0344dc1e6c6897c0f48"
    sha256 cellar: :any,                 ventura:        "180a3fe88614125cf463f1bbef1aecd4441e63fb44c2237869362f6e211e85d0"
    sha256 cellar: :any,                 monterey:       "f284d6ba5bc503600a3aa563dbba3f0b67d4806bc8627a5e137c1ffca5084c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56835a77df27fde33736fdb3e70ff3c6862c17c29b6ff7a971824229dfee1912"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "rtl-sdr.h"

      int main()
      {
        rtlsdr_get_device_count();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrtlsdr", "-o", "test"
    system "./test"
  end
end
