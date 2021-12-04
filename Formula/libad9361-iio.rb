class Libad9361Iio < Formula
  desc "IIO AD9361 library for filter design and handling, multi-chip sync, etc."
  homepage "https://analogdevicesinc.github.io/libad9361-iio/"
  url "https://github.com/analogdevicesinc/libad9361-iio/archive/v0.2.tar.gz"
  sha256 "f0d935eb7f70fde8596d98e9eb1f311b408b87662fc1fff45ae3ed455697b747"
  license "LGPL-2.1"
  head "https://github.com/analogdevicesinc/libad9361-iio.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "libiio"

  def install
    mkdir "build" do
      cmake_args = [
        "-DOSX_PACKAGE=OFF",
      ]
      system "cmake", "..", *cmake_args, *std_cmake_args
      system "make"
      system "make", "install"
    end

    # For some reason they install a framework in lib/
    frameworks.install_symlink lib/"ad9361.framework"
  end

  test do
    assert_match "ad9361_fmcomms5_phase_sync",
      shell_output("nm #{frameworks}/ad9361.framework/ad9361")
  end
end
