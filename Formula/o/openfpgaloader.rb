class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cf19b596e5dea21891b1be3cb9a04be7a1501926ee0919dcc5c9f1b6d3bd0a96"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b9207b7099937acb9e926b69b49f33281bf8d08e3558aa35d4846f681f0e7ec1"
    sha256 arm64_sequoia: "b217a3ee5dc8d327297b48799b4d3b9faa862c0e87c70e1df5e840769a509149"
    sha256 arm64_sonoma:  "0efaa2b14608d264fb1fc6bffef6d55f95c55ecf6d07a2b6abbd447acc94280d"
    sha256 sonoma:        "f46d32ce54fe5935ae691dc5af7b888583ed4fa8a71135b9295248d1e7d296c3"
    sha256 arm64_linux:   "210c9f278ed7788d5e5f9663b8534a16efb2c15b45073b72c15549cda1c0c3ac"
    sha256 x86_64_linux:  "0bbf089c13b16a3aa1b26ed8ea95cc56c8bf35d2e2cb127b05aabfc2a795e48a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"

  on_linux do
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
