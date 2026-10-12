class AndroidFileTransferLinux < Formula
  desc "Command-line MTP client for Android and other MTP devices"
  homepage "https://whoozle.github.io/android-file-transfer-linux/"
  url "https://github.com/whoozle/android-file-transfer-linux/archive/refs/tags/v4.6.tar.gz"
  sha256 "d8bcbd1ea5854e2653661f7e953c955531eed540ca9aee966ae9bb64149f69e4"
  license "LGPL-2.1-or-later"
  head "https://github.com/whoozle/android-file-transfer-linux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0995dee98d1aa89c9190c32a295d6f5d4501170957660c80478274639846f4c2"
    sha256 cellar: :any, arm64_tahoe:       "9c78f94ff23b86953403c7cb98850c7451d3dbb99797fc34cdfb91a049b60af9"
    sha256 cellar: :any, arm64_sequoia:     "8c957e831a5b063889bc227ad54a3ad4b91d1df529432b2691a18b0cba527b0c"
    sha256 cellar: :any, arm64_linux:       "ee640079803ca6dacc6cc6e5b674969db71ac4b8c6d3443d311855f04f4dedb5"
    sha256 cellar: :any, x86_64_linux:      "3f0ad353f5ac9c2c1ece2d127432fa4e1b81d495f80cc86865e20c28e559f1e2"
  end

  depends_on "cmake" => :build
  depends_on "readline"

  deny_network_access!

  def install
    args = %w[
      -DBUILD_FUSE=OFF
      -DBUILD_MTPZ=OFF
      -DBUILD_PYTHON=OFF
      -DBUILD_QT_UI=OFF
      -DBUILD_SHARED_LIB=ON
      -DBUILD_TAGLIB=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "batch command processing", shell_output("#{bin}/aft-mtp-cli --help 2>&1")
    output = pipe_output("#{bin}/aft-mtp-cli -b -d homebrew-test-no-device 2>&1", "quit", 1)
    assert_match "device not found", output
  end
end
