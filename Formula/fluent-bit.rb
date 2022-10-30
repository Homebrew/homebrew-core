class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.3.tar.gz"
  sha256 "d2616fec54c49330f7bc583b785fe2beedc762dfb6df0eb7985bd58359ca3693"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "493972cc539a1934d850bb7c262835996137dc178528d63a656bbda93cddd88b"
    sha256 arm64_big_sur:  "db2f0ac04b406715ee83412664b26eb3893825045b7c18839d6e229688743ec2"
    sha256 monterey:       "b423717a304a121dbef304b197c8a71da11ea544585a5a3c137e6b2bb4877f22"
    sha256 big_sur:        "579d21a3b2c06c5b77a2a7f545fc0e914beb56d4598b642499adda59805cd7b6"
    sha256 catalina:       "37089701d9698e4d45d79c7ef30140a1cd3ad666261bbdbd3235809ceb0e1e48"
    sha256 x86_64_linux:   "76ccc243b4255ce3229ebc6de3930116270850b8879fe75fd7ab0ea7ad755828"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    #
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
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
