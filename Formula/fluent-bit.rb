class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.6.tar.gz"
  sha256 "363e8c0bb9331b85abdc69b33a8c77de0a78557fe61734ea6026ea8d28863d85"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "daccc7851b1caf153122a4dc739ae7553783cdd41961ffea6ffd162431bf4774"
    sha256 arm64_monterey: "9f723bc0ddacff4111bb85353581268699ce329be2ebc9e63a1f85894980856a"
    sha256 arm64_big_sur:  "d6abe2db1e18c7ff88d7592a46ff106606d610690fe7d036e90a437a842eb49d"
    sha256 ventura:        "d94908d12a51ed32fab6529b167df4b22644937929fa3e0e4e4487cb423b5b3a"
    sha256 monterey:       "2a1debaf30cbf27a157e89969964e4cfed66a34465dfbfdea0cd0a062ea32ef9"
    sha256 big_sur:        "11db473b6d0b1c78431b5e3e2bb5d1c90cf4bbe5f25581b3e37dc53451dcce20"
    sha256 catalina:       "1aceb9c24f5b169710f8e4ec12beece8322dfce7005d21a3e342f73e3a430d1d"
    sha256 x86_64_linux:   "2f4ac5408ee1ea153c1a147ba68a3e801b63967f251532c36b0fc2bd82271ad2"
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
