class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.11.tar.gz"
  sha256 "ada2a71066fd259d064bfd4800ad959a6b811606a6d3b6a8949ebb406889cbff"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "9b6f87c82753883bac45169784a7f2538983cdc5e88c1b64f65bcad652116e07"
    sha256 arm64_monterey: "d9ea54d9634a9ac9a3c86689dc6957a16f9a73f917797db5be4cc5f128f90fc2"
    sha256 arm64_big_sur:  "3d24e1aabd1e60db33f94e8eaff961a27d4d042104acb4c708e54e93829ebda2"
    sha256 ventura:        "793b1169b3914329de678e51dcc7cf899488ac2386bfdbad8d76e49097853345"
    sha256 monterey:       "8b31b768a16b32a7247fbe188be4ac670ecebe854d16e4788575956304846243"
    sha256 big_sur:        "2fd7ee0eb70ce17098febafd8237088698f5802118f3febfb571d66bab63145b"
    sha256 x86_64_linux:   "93e9b8c4a57a3ec97bf6e08685efcddfb5aefcfe2f193ccfb739b85f68cf7dbd"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see fluent/fluent-bit#3393
    inreplace "src/CMakeLists.txt", "if(IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
