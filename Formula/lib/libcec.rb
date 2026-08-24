class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.6.tar.gz"
  sha256 "e1e762fee8589def3cbceb1f3e53ba06ed5b557a2705b86a225f8f30fb19c79a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5fc4d3c1d1a28dfc0653926f0e16ac18c2f1afb66d478cf984f766e97b0e666a"
    sha256 cellar: :any, arm64_sequoia: "4ddc5f556560b8c32901bf5aa0fb5df076620f758cf648e78003fbf12676544a"
    sha256 cellar: :any, arm64_sonoma:  "15a1484174df4ba7e6dcd710dd026b1e564560be290a0b0a866eaa31620355c6"
    sha256 cellar: :any, sonoma:        "7d638a3d24e44972d9ae81ea8fb99d4a65eb0a74a5429d80f8c4e62377c6d4c2"
    sha256 cellar: :any, arm64_linux:   "2841ba36261b1d933d777a23ac7ade753a4ba7ceb8222195f7e005a6ad501052"
    sha256 cellar: :any, x86_64_linux:  "7eb908c2e6125d8550033f7672d8360f6655daa92447cbe535021d85227eebe2"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --list-devices")
  end
end
