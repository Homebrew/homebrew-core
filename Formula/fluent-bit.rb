class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.4.tar.gz"
  sha256 "fb5b5c0a9a8283912ec3c624ddf04a804b0e38f74f087ea7bc5b1319dc57a46d"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "47b66e4106e29d832608c956cebeda0e6bc0b199962b679d1a337f80b1297a31"
    sha256 arm64_monterey: "4eac3d4bb36346cb7df113842b1cf6c611f54af1b223628a3e741863cffdfcd6"
    sha256 arm64_big_sur:  "2db7028ab4388ffb98bc28162073dfbc63ee4ff545687d82b96a22ed8a610a65"
    sha256 monterey:       "941f4bc7d3f669053247429f658d579835f04d7214409a4a8257dd57b431e46e"
    sha256 big_sur:        "7584105ba07958d9a45cd419bf7e36b9927e3a48ccec42cff2e6e7dfb37b8cd0"
    sha256 catalina:       "4dd56901f1d4462bc42bc08fd6b5f6744a13a07378d93b7dfb2e781b09fc5b8c"
    sha256 x86_64_linux:   "8ead1695255c7cecdf79048d76a32f755c53ee23203fc6c3a61da02a0a89c673"
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
