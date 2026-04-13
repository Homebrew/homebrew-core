class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.11.4.tar.gz"
  sha256 "452922112dd19770b06cee61c8bd6fc34899c5b3727a275f8d7c1de6b372fd74"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3f42a9316052846dde1abf3f11c03d5948dc880143776c56ca34df08c17e4f5"
    sha256 cellar: :any,                 arm64_sequoia: "1bdfe5c1b854fe9f2ecf0ac9b7b9e00f83a40b27d17290f2ec9b433f75e93873"
    sha256 cellar: :any,                 arm64_sonoma:  "b7fe5c9de9ce4e486102c52b7046696ad3b18c5d1aebc116ced84488ac361729"
    sha256 cellar: :any,                 sonoma:        "90f1406f200984148625141dbf780aaadb34e8d33116834ad9b38d8dd5ee9a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020412551cd3c47c1fffe064f6dd6419f782160d39aa98436ea9dab68ecb47e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c9ecffc598208c6c399d1cd28cbfcb093da8bba5d925e9294afcb304322f3e"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "xapian"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for xapian >= 2.0.0 which needs C++17
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 14)", "set(CMAKE_CXX_STANDARD 17)"

    args = []
    # Workaround to use uuid from Xcode CLT
    args << "-DLIBUUID_LIBRARIES=System" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".nmail/main.conf").write "user = test"
    output = shell_output("#{bin}/nmail --confdir #{testpath}/.nmail 2>&1", 1)
    assert_match "error: imaphost not specified in config file", output

    assert_match version.to_s, shell_output("#{bin}/nmail --version")
  end
end
