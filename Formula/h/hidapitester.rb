class Hidapitester < Formula
  desc "Command-line tool to exercise USB HID devices via HIDAPI"
  homepage "https://github.com/todbot/hidapitester"
  url "https://github.com/todbot/hidapitester/archive/refs/tags/v0.7.tar.gz"
  sha256 "a20f805e308592f79c9ea4ecf74d9ea36a267e222b3c3c49c18f7b980a67ebbe"
  license "GPL-3.0-only"
  head "https://github.com/todbot/hidapitester.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "92b3acd725d9737c5bf926b6ca3b404821fb0774cbe27db5e64d980a83d64891"
    sha256 cellar: :any, arm64_tahoe:       "7558d2ab90eb61bb206deeb1f189c5c3eef85531024bffc7ae4f229180766902"
    sha256 cellar: :any, arm64_sequoia:     "c9daf7ce18a77f84d6cc5bf55744293ff22522b80caf775d7e9f61fc72341a31"
    sha256 cellar: :any, arm64_linux:       "1b8b5905ca1ce23c6049e7dc8cb4d45ba4e98e35a9669d93289dcfdaa2f11613"
    sha256 cellar: :any, x86_64_linux:      "bc4cb553e4c60641b5c63fbf23234321fdcee63e1303e9df605b5ed706f66bb6"
  end

  depends_on "cmake" => :build
  depends_on "hidapi"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DHIDAPITESTER_VERSION=v#{version}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hidapitester --version")

    output = shell_output("#{bin}/hidapitester --vidpid 1234:5678 --open --send-feature 1,2,3,4,5")
    assert_match "Opening device, vid/pid: 0x1234/0x5678", output
    assert_match "Error on send: no device opened", output
  end
end
