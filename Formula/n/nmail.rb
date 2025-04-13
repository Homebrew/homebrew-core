class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.3.5.tar.gz"
  sha256 "071abc7c9c1d5a26616410872d4f7310cd00416f8da0860e1f368ca642ccc025"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad85fcda664abb479da1987b08db30ee771fe3849a4d6404ea01c7bc0a825f86"
    sha256 cellar: :any,                 arm64_sonoma:  "ec679ac66014b1bdb790eef728a4c764b897108e16fa8f4d6b1cd71820db15af"
    sha256 cellar: :any,                 arm64_ventura: "eab5136e31ea85b132d73fd1f75ed4a012c25ee4ccec988014afafe793a5433c"
    sha256 cellar: :any,                 sonoma:        "c6366c79cec519ba80affa909fc5d5fac5625ec9021f9fad4e67d2764e1448d5"
    sha256 cellar: :any,                 ventura:       "bca75663ccad1aa91b3e0b77a2d7d00c154b9af8830b6995b756ece98633ac9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dff943a711ddcc3cb08b5d72084e5ad1ccb4bb42b6b9742277f812ef81989a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca812e369664d021c573813a05034e7f87e0be9bf4a6ac6e2569af372f2bc26"
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
