class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.14.12.tar.gz"
  sha256 "d089e315bcca1906a2bd12a940ad7ebbc0b62e10ed1d2c12a952f2cf8ad71556"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "02d2057b571c8157a9dada00ad4a44b25f685c506993cee1d66ddcf0882766c1"
    sha256 cellar: :any, arm64_sequoia: "a5eb93e48963d76ff103fcb48760166a80009e2c406b294685d54de0de28f53d"
    sha256 cellar: :any, arm64_sonoma:  "6af2a10b1c3f5544b7aed08978d29ead68df6d7d54fcc9359f89c18fd683af9f"
    sha256 cellar: :any, sonoma:        "dcf27dfe6d4e21ef947a8950a5dbbeff3da166acea38f251e8f9a74f3055751f"
    sha256 cellar: :any, arm64_linux:   "79a22e4dcff4418e6046909aff0baa4432bd2ec9e5addfe077e5916aaeeab534"
    sha256 cellar: :any, x86_64_linux:  "4946549e9c859897eae73982b0c3152905a242cdb8fac8042df83d8764ee254d"
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
