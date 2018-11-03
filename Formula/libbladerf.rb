class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2018.08.tar.gz"
  sha256 "6288c230dad26e32236a4b60f0b14c129e6fa0ad91bcf1c40abe8789b352e51f"
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    sha256 "67091f5edf6c3108798b87e45d1f3a81f601037f1b5fa2fd25232ddd7e68a36b" => :mojave
    sha256 "1aaf3355a29e6c318555afc4a4aff2c76957976c7cf00113af5cacc8a171ab75" => :high_sierra
    sha256 "711db5a38f3a217cd3fe54c19fe8624bdb6d7b4431176a74541e819414a064d1" => :sierra
    sha256 "9de01abf00d154167160155eb6c64e9c9f83f11f8c0ce2ba862e94db43c9cbe2" => :el_capitan
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
