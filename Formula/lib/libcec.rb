class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-7.1.1.tar.gz"
  sha256 "7f7da95a4c1e7160d42ca37a3ac80cf6f389b317e14816949e0fa5e2edf4cc64"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a2f85ce7242058e838d66f633131d1fdd3d19dd7fddf1a84f6678db006999e1"
    sha256 cellar: :any,                 arm64_sequoia: "efd0e7facb572876d72798c1b07df84e55ba4af2597645342784e667c9750f50"
    sha256 cellar: :any,                 arm64_sonoma:  "d886ddba0e875d545547820c13cf9b22d5c676253512008c8527aaf95454d3df"
    sha256 cellar: :any,                 arm64_ventura: "be082ac4c53c7d700acb7b5f91e9bb965652c9056e76549d3e067fc734c5794f"
    sha256 cellar: :any,                 sonoma:        "0b819287c07576627c5029b3c57d295ef60fd8e8d8f25d6876b8362c7a03c2db"
    sha256 cellar: :any,                 ventura:       "0995d3ba61e560dd6627fc093301c6f99ae1488b75bc49c182c659ef1dd5091c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "680f4262c03b5a10e88bee7ba827762f84e38d943d68a8d0ca61485738f97128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e8795e972cddb728bd93304f2a97ded54988e0a5a253d13a6a2a683d0e2c2f"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  resource "p8-platform" do
    url "https://github.com/Pulse-Eight/platform/archive/refs/tags/p8-platform-2.1.0.1.tar.gz"
    sha256 "064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0"

    livecheck do
      url "https://github.com/Pulse-Eight/platform.git"
      regex(/^p8-platform[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  end

  def install
    ENV.cxx11

    # The CMake scripts don't work well with some common LIBDIR values:
    # - `CMAKE_INSTALL_LIBDIR=lib` is interpreted as path relative to build dir
    # - `CMAKE_INSTALL_LIBDIR=#{lib}` breaks pkg-config and cmake config files
    # - Setting no value uses UseMultiArch.cmake to set platform-specific paths
    # To avoid these issues, we can specify the type of input as STRING
    cmake_args = std_cmake_args.map do |s|
      s.gsub "-DCMAKE_INSTALL_LIBDIR=", "-DCMAKE_INSTALL_LIBDIR:STRING="
    end

    resource("p8-platform").stage do
      # upstream commit, https://github.com/Pulse-Eight/platform/commit/d7faed1c696b1a6a67f114a63a0f4c085f0f9195
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
      odie "remove CMAKE_POLICY_VERSION_MINIMUM env" if resource("p8-platform").version > "2.1.0.1"

      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --list-devices")
  end
end
