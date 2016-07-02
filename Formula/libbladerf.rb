class Libbladerf < Formula
  desc "bladeRF USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2016.06.tar.gz"
  sha256 "6e6333fd0f17e85f968a6180942f889705c4f2ac16507b2f86c80630c55032e8"
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    sha256 "a0f5f3a24237452816c8d25caf2d615d00bf54b1f5f1afaac3aeed3db24dfb06" => :el_capitan
    sha256 "da20c9f91d238d89aaf62499c7c2db6584685868c25289a680a1c2d816ef88cc" => :yosemite
    sha256 "c41f40739255834f95fb69b19c6ec2827fd40b84ef24b22640620b3a66fe7c19" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "host/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
