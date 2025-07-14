class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "204fe05ac8f960529e65d20cf88cef03773f4c40639eb87795e40999f2086be2"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8f8553d4bd15c2839c7f4c16d35e882711c93d2c736c6bd0f2f402f85bb39d1"
    sha256 cellar: :any,                 arm64_sonoma:  "90c4ae49c423e3045acf767a01d71ac55772a9cca192f4867eee8c3a87a2923b"
    sha256 cellar: :any,                 arm64_ventura: "71e1613fe8d13756f6a51cadbe734e62e5f3a8c3f4a29eb606f49e3630d3c9b2"
    sha256 cellar: :any,                 sonoma:        "3bd6de152112e4e18f0ba7e544654e0fdc646b9f0159b7d509a69bd05ab37ec9"
    sha256 cellar: :any,                 ventura:       "5404a07c2fc058dbc992ac2a793e6f92bce05e079c830e11fff914244dde986b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc502b1564468a7f2caad62fe1cf6517a8dda8d4f3e453b6fa9ea2ddb2d2ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01ff8ab0972c78d811448956ba724fbabf111ff6be7a427bb1cfac787cdf4bd"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
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
