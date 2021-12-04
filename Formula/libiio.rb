class Libiio < Formula
  desc "Library for interfacing with local and remote Linux IIO devices"
  homepage "https://analogdevicesinc.github.io/libiio/"
  url "https://github.com/analogdevicesinc/libiio/archive/v0.21.tar.gz"
  sha256 "03d13165cbeb83b036743cbd9a10e336c728da162714f39d13250a3d94305cac"
  license "LGPL-2.1"
  head "https://github.com/analogdevicesinc/libiio.git"

  depends_on "cmake" => :build

  depends_on "libserialport"
  depends_on "libusb"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      cmake_args = [
        "-DOSX_INSTALL_FRAMEWORKSDIR=#{frameworks}",
        "-DOSX_PACKAGE=OFF",
      ]
      system "cmake", "..", *cmake_args, *std_cmake_args
      system "make"
      system "make", "install"
    end

    Dir.glob("#{frameworks}/iio.framework/Tools/*").each do |exec|
      bin.install_symlink exec if File.executable?(exec)
    end
  end

  test do
    system "#{bin}/iio_info", "--help"
  end
end
