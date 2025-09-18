class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.10.tar.gz"
  sha256 "7d8b28b37ad54f60dc361ea1c98b52725f3b4a6b55ded6275d23499be9003f83"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2dfa2b6ec6efbd10c4286ab8fcff329e607408bf60c81bfe708e313c410e537a"
    sha256 cellar: :any,                 arm64_sequoia: "c609e3c9bd49d9b640e78fa4750bc9e7c0967d6f4d947a08d98f4499fe5e63e4"
    sha256 cellar: :any,                 arm64_sonoma:  "cd920ce438a5b9f5364fe34072df4a914361ba24ef70715563c8b9b590bd9270"
    sha256 cellar: :any,                 sonoma:        "56a7ee82ca3d9d691a0136ef622b732f88262c617410d609dc2c4d43004edd9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d96dc08f0fe892b3e7c1df8ef642241065a5dcc340eab628985dac813456029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f2a3ae9171b7ca37849ca5b4c030fdfcb77ac66bb4cd90cb680743d40c37299"
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
