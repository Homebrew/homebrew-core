class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.15.8.tar.gz"
  sha256 "51f763e310c5f4467a17a926a0e3b8b2eaeb166af888b3f0277c46b2961d56e8"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d03f95813a44d8d10823aa7658a3a317dafa3090c72265823b9222a7e55ab0e2"
    sha256 cellar: :any, arm64_sequoia: "743f40ad3da2dabbeb12cf886b5d421a40777c31d4fd9c0b997bef713d21c472"
    sha256 cellar: :any, arm64_sonoma:  "63a7aac49b893b99575e345a09092f24c3e3b86c40314323b96b2c89bde25cbd"
    sha256 cellar: :any, sonoma:        "430855416092be503b0c30718d3c23dd2545986a8cc489d72611d8cd3badcf0e"
    sha256 cellar: :any, arm64_linux:   "ebc0469ab79db456e1ef77c67a5a5c742a1b36cfa4b90ff8f2eab28b1c5d6967"
    sha256 cellar: :any, x86_64_linux:  "b46e3c70199307c937a6c0723a42bc98def0096a8acbea769652247870f5545f"
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
