class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.10.3.tar.gz"
  sha256 "a667b410a865eef7fb08ca9afceebf6a9a85c61850df875005255a88960c5158"
  license "MIT"
  revision 1
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0df9085e3fd3f6159aff82e2821ad7a6373b986687f5718ce7cd9946137229bb"
    sha256 cellar: :any,                 arm64_sequoia: "6ecbed5a66d69ca72ac2d9086f3121f0c114cfb4a17d8a413b02772eff3535b0"
    sha256 cellar: :any,                 arm64_sonoma:  "3f629805d5881d9364e2268bf01e557b6d71d35c9ad50bb9ae383363a39aa7cf"
    sha256 cellar: :any,                 sonoma:        "47fc11e7c11ab93a076ec18677bcb39982b33c27ae1467e723424cf19b6b1376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8933e4f5f23be97255198e5c8127b1e443cd141621c15c12ca64bb1b8286bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e50beeb86945cbd1c3dee085aa614c087391729e06a7b01517528e1bcc8e98"
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
