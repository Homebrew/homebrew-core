class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "c7d276238d25242467218941842d8cd4df6cfa52cc9379ae5755220cdefd1dc1"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aee19e6bcc47e7a7ccd3916aa705226cd6ac9e20bcaedd86f5f962c49f88c93a"
    sha256 cellar: :any,                 arm64_sonoma:  "7e09a3cc8d3b15650adb3d7c4af971842d0febe485d98a72cb339f1f28399e30"
    sha256 cellar: :any,                 arm64_ventura: "fa7dc4f37309e141cb113605834ec4ecce89178c58ad02088a8f64292e593a80"
    sha256 cellar: :any,                 sonoma:        "727f7263cac717ce8645a406ebce75d37f8a03df2e118044bfd08caa0b0ea24a"
    sha256 cellar: :any,                 ventura:       "35e7de0cf69653efe8b2d8adb4a96bf0209418b3628d6cbe02be8b94a098779e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66fe3e628b4c7bc6919583e3c143ee21961f89a3b898d4b885708489a0a87156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceec22065d8b1b4949feece04ee97f83088ab71dc882de1c637d50bd7911ce6a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
