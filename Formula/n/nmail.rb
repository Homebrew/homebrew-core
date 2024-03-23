class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v4.54.tar.gz"
  sha256 "e91880119a07f4095970b1a5bed8fb42300d233f9810eb34c8a0c4c25da4a836"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b5ddaa1658002e87fc4e29f5915499cac70d19fc8c1acc89d971592c5d5575f"
    sha256 cellar: :any,                 arm64_ventura:  "76689a59aac947566a19f32d0981806ea7a419dde9c582e85984cddedd8a093e"
    sha256 cellar: :any,                 arm64_monterey: "31e4d3e1032582cff518f08a6a896c7f21dc3d6f4c8d60af635be49f92aa9f2d"
    sha256 cellar: :any,                 sonoma:         "120ea973b0a3a793e0093665c4feb311925d12c46fda7d3c2f2bfa6bac36fb3c"
    sha256 cellar: :any,                 ventura:        "accadfdebb426c8d6d35d73ea005a0b910a1ddcacaddfd715263bdbf5474517c"
    sha256 cellar: :any,                 monterey:       "2dfa04c3550b52f58669613f848f6af0434a08d8d2d3d58c8d5a0e4185c68b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "468f9cada315f603bd4575dfff3f439a2d097cb64f3916842f8485e61b3d2e45"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "util-linux" # for libuuid
  depends_on "xapian"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".nmail/main.conf").write "user = test"
    output = shell_output("#{bin}/nmail --confdir #{testpath}/.nmail 2>&1", 1)
    assert_match "error: user not specified in config file", output

    assert_match version.to_s, shell_output("#{bin}/nmail --version")
  end
end
