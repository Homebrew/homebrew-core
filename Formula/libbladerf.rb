class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF.git",
      tag:      "2023.02",
      revision: "82c5bfd68d1937542a508f031d536fdccabb3985"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://github.com/Nuand/bladeRF.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6adc60a0374ce3ae955b395bd09df471af0f6028cb3291d2819336740007e29b"
    sha256 cellar: :any,                 arm64_monterey: "7c7439dd72c4491dd70b6a5f392ee08c640cab30ab8e0551b3fea0c8b28b5faa"
    sha256 cellar: :any,                 arm64_big_sur:  "e47a7c91f79758372b13475fc52b4f280c79d590e04f1533b983d333b532b156"
    sha256 cellar: :any,                 ventura:        "be1151464c481df3d379faccce8c7e098223c130c56e9847e09d22314896eef4"
    sha256 cellar: :any,                 monterey:       "57474d88710d7b349d7509e81946c253d12e68c3635aaebdb50fdad66724f853"
    sha256 cellar: :any,                 big_sur:        "ff5e28d57aeede24d33c6b5dc3175b085878acbaf0881a2a07da40a464708cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f5b14af524f2020cc3c2133bce52375101a941dc335162809a9246e2a5bebd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc" if OS.mac?
    system "cmake", "-S", "host", "-B", "build", *std_cmake_args, "-DUDEV_RULES_PATH=#{lib}/udev/rules.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
