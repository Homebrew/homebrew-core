class Librtlsdr < Formula
  desc "Use Realtek DVB-T dongles as a cheap SDR"
  homepage "https://osmocom.org/projects/rtl-sdr/wiki"
  url "https://github.com/steve-m/librtlsdr/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "851b87a62e548470c287c26669b83abb665d83bccb8d8492d07a697c7b9c4e37"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://git.osmocom.org/rtl-sdr", using: :git, branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1ef52cd62e7fa1315e492f22da0874d3e2f9c274e70bfcdc01aa3eaa76cbf3f"
    sha256 cellar: :any, arm64_sequoia: "0a215936e5eba74c3ef18f90d6c476d5cc2805c6f712c8860589884fd1c00acb"
    sha256 cellar: :any, arm64_sonoma:  "994c6bb84127a275f8ee544ac82a547f851689402bfb18094b57764e658d2a9d"
    sha256 cellar: :any, sonoma:        "362250281e27728ac74510169bf7eed09e4b1d4d76228589eeebf8dfa32430c0"
    sha256 cellar: :any, arm64_linux:   "4b77f074acbf2e6b28ac15792883336d88edb61fae1667db8b0614c0e9af0d08"
    sha256 cellar: :any, x86_64_linux:  "7e1499436613a42addfa1f027440ebe5c14361b972e2834718c3b9e2ceca82ce"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "rtl-sdr.h"

      int main()
      {
        rtlsdr_get_device_count();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrtlsdr", "-o", "test"
    system "./test"
  end
end
