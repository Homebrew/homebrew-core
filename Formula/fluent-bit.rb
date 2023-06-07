class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.1.4.tar.gz"
  sha256 "27c50c04cc39f4327a168c7eb00b7ab9d587d1b414f046668bb6ba93020ac7a5"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "6b11b1de3b6e2d7f669aef893bd46a187e503dae358c8c3e3faa80eb4b0c8b8a"
    sha256 arm64_monterey: "2b8f32b01bf315bd89dddd4dedd3eff81ea5a44b27d7598c129f2bd54b8a5fb9"
    sha256 arm64_big_sur:  "15966222b1dab6511012e6469135b5c9a12bc2c303bed667e610dfd11d9ebe1c"
    sha256 ventura:        "f322e0a5316371d45626ce48732a818ac741f6c7ae9a52b601be9b9c9a082960"
    sha256 monterey:       "dc2e6d8446d7c789c9b34a55c45729a7d13c7ff8fa79ae6d0de15269211963e3"
    sha256 big_sur:        "9a2dd89f3ad8c2beaa4fb25cb87bea1aa2aca9e718cd453e676e8e2394ac788c"
    sha256 x86_64_linux:   "3305a0d0687811c4e65e4ef30606f1c84535dbcf4644cfa465545069de8187a3"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
