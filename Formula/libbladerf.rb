class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2018.08.tar.gz"
  sha256 "6288c230dad26e32236a4b60f0b14c129e6fa0ad91bcf1c40abe8789b352e51f"
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    sha256 "b0d2d3fcdc875992153cb28bbcacfb0bdb393cd2f60e6387415393dce24942d9" => :mojave
    sha256 "d00a1061f4265d7f96e463893402556ab44c2a350a7d9808fe9a2ada90d74e3c" => :high_sierra
    sha256 "dda3a182c1664f4a541dbc79f50e2bcc0fdafee4d65ccbe7619722deb6afa64d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc"
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
