class Lm4tools < Formula
  desc "Tools for TI Stellaris Launchpad boards"
  homepage "https://github.com/utzig/lm4tools"
  url "https://github.com/utzig/lm4tools/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "e8064ace3c424b429b7e0b50e58b467d8ed92962b6a6dfa7f6a39942416b1627"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13fcc858d9be77a53c1d7a541d3c314c1b98e03b48c2391850912f6dba3d6c85"
    sha256 cellar: :any,                 arm64_ventura:  "fe9a6bc3e16b5d44eb6eb84c108c47b2b6a766b0160326627596c339697ac862"
    sha256 cellar: :any,                 arm64_monterey: "ebc1bb78c1f8f5db4ecefbebed152042612d512d92e3339836410bfcbe3888a4"
    sha256 cellar: :any,                 arm64_big_sur:  "62a47721a948ccb49f1429fd8649daf1e894e90dacbd45566564b8cbac749a9c"
    sha256 cellar: :any,                 sonoma:         "e0ba1978e09cb4307a5caf782622db027b1e2af93f929c3b9a73b0ed8d3fed32"
    sha256 cellar: :any,                 ventura:        "7c481d7dfe7be9b57aae020c7a46fafd5de306cfd687b02ec4857e4db9d694cc"
    sha256 cellar: :any,                 monterey:       "1bef37edda64611296ac2ba9df91d92d082dd2da0cac5673ef8735d0704330a8"
    sha256 cellar: :any,                 big_sur:        "2fca09b10fef4d8304ba4acdce164bbfc5f4fa9b8dd1eb6fcb60b8a58c7ac8d3"
    sha256 cellar: :any,                 catalina:       "5d2e503a9c94226f9d3c6d1da1a54424be1c9a16279bcc94253ab0e2da2a3718"
    sha256 cellar: :any,                 mojave:         "a0bb88705b97875de770b1979b5480521007b25efd627f092e178941b8ecd4ec"
    sha256 cellar: :any,                 high_sierra:    "9c65eb6694f74b513b707c237cf13bb6a54b9e4a188582355f78e94f9ac53407"
    sha256 cellar: :any,                 sierra:         "3238455d6329e9749700b9c12c2e7459b63ea400fb0e7e6818b8c7c9b77b4e6d"
    sha256 cellar: :any,                 el_capitan:     "7c6bd7ec1a220de95089d71f79baa61ce459ffa0d00d32af727435594ac7603a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5afa96bcdab63596529b9202a6c985a4a1cd634235b2a3ab099805046384e405"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    # Fix for https://github.com/utzig/lm4tools/issues/32
    libusb = Formula["libusb"]
    inreplace "lmicdiusb/Makefile",
              "LIBUSB_CFLAGS := -I/usr/local/include/libusb-1.0",
              "LIBUSB_CFLAGS := -I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"
    inreplace "lmicdiusb/Makefile",
              "LIBUSB_LIBDIR := /usr/local/lib",
              "LIBUSB_LIBDIR := #{libusb.opt_lib}"
    inreplace "lmicdiusb/Makefile",
              "lmicdi: lmicdi.o socket.o gdb.o $(LIBUSB_LIBS)",
              "lmicdi: lmicdi.o socket.o gdb.o #{libusb.opt_lib}/#{shared_library("libusb-1.0")}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/lm4flash - 2>&1", "data", 2)
    assert_equal "Unable to find any ICDI devices\n", output
  end
end
