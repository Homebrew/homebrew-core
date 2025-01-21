class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.2.2.tar.gz"
  sha256 "68069eac3cf383717aafa53370681110d269a19fb6f70e41931b60c3cec028a8"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d275b54913a5f473abb6a02b28d6498490c67f7cbb4470b2762e6221f4507ac"
    sha256 cellar: :any,                 arm64_sonoma:  "3a80270b1459ec99439306d36b662c4c4d1a7ce4fd226eb348c7fd29057316cb"
    sha256 cellar: :any,                 arm64_ventura: "a4274f3ffdae5d1f8aff7a4b542cac00efa2fe1479cb67009cd91870f62502d6"
    sha256 cellar: :any,                 sonoma:        "535dbd727f545294b59218ea0c66e16980051396abb0849efbc9230f0c5f3e06"
    sha256 cellar: :any,                 ventura:       "3a8402c8993958891d5545cdcbd76fa912e15594e314cfc0b1a9905c7afcfc86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3906de4d0a70c7963ab071ab1632b688aaa83173796ad207816a9be20ac4b764"
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
