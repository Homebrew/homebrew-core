class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "4b7e86718df490c0e3b8546ceefa9f82cae4683dcc0dd4bf08a3d9b47c26436a"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "66d1a65a4f5e2d2ff63b23db6bd9fb8b39cda6862ad8a981eb586f672d01cff5"
    sha256                               arm64_monterey: "4868c5c5f603b8672a815a6f26a3209f4378cfc799e2b4fe92f3dc0dd68bd176"
    sha256                               arm64_big_sur:  "aca431622d0c259d0338916ff8a55c308b357c9da9e213fd3843cd06d213bb27"
    sha256                               ventura:        "bcec36264f44738006220251fd9431da33dd9cf427ec50fdd1a7808972ce3cb9"
    sha256                               monterey:       "04f979693612a88cca0ca033c281da5e1ae3be7817c1475b666ce2dd8a7fd9bc"
    sha256                               big_sur:        "e73a4108147b3e28166f89087d58b2cecdf7ac1561ee21288616036ace90e9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1299aa1679c48fab3b7ac9c40195b8b8e09eb6b381acbeb112344280ca0d9e7e"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"
  uses_from_macos "zlib"

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
