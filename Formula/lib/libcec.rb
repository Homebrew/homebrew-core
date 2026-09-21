class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.7.tar.gz"
  sha256 "e4ac4d1dd3559cf83189d29ab40fc5537b5a2beceb82916ef173dac7e50dbfa0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "94d9e2cada097a78f3ceaca610eecb6113f500f30aecc9d5556f2575cb6b5bdc"
    sha256 cellar: :any, arm64_tahoe:       "7cb2c4f58345e422d49ac65322fd716bc9a8ccff8df55cd5e5a6315e53c2103d"
    sha256 cellar: :any, arm64_sequoia:     "4b48b01de2b23cfe3679d19b66296231c34e283da6b263d839eab8775346d01e"
    sha256 cellar: :any, arm64_sonoma:      "f7af7941ff58d3480935bfe8cb66984c05e886539adf79944f08a2a7c3943470"
    sha256 cellar: :any, arm64_linux:       "28bc3e9f43da1ab4cd511b37994d97b83225b55cce759483f023dede587bbce9"
    sha256 cellar: :any, x86_64_linux:      "1952bbf337b1b0ff317671f4756a08cf77653d0a849e73d479c73e28cca90fa1"
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
