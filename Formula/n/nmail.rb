class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.17.26.tar.gz"
  sha256 "a002b62edc41369785754170d1a8b67d377caa5cf5fb8484668400e97eed274e"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    manifest_sha256 "c588b8bc2a37091357213d209289e308970c8de965c0dcae4f08c2aa67454514"
    sha256 cellar: :any, arm64_golden_gate: "3c32e01bac7910a4c9a19ca82c80300c58d5e7f14b871554416ebce5aa4bb74f"
    sha256 cellar: :any, arm64_tahoe:       "6cb20ef8667f43781d7200c2d00bf015d85f3e44536e69026f66bb2aff4849d6"
    sha256 cellar: :any, arm64_sequoia:     "08290551ee8926016396e3481fb1e8d1b811777164c374e4d20211c8562d8c42"
    sha256 cellar: :any, arm64_linux:       "28d18bbcf216bce53c518f47774e6b58c674bea6ae763882ec2257010c52e29c"
    sha256 cellar: :any, x86_64_linux:      "fa02f4f0d8149350c8e7ad9d0d423f50238baac47e5c09a203c744926b44b8ce"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@4"
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
