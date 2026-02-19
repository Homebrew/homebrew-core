class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.9.2.tar.gz"
  sha256 "349217973622ee7d3d3b1ad6e7108efa4926d0f9324839b04a8d22f52e3e6a8d"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ab8842a446c108d251f2703b15f39a2680fb666d2e5be3458d68cc6300d28671"
    sha256 cellar: :any,                 arm64_sequoia: "8b1a19b7785b3e2d283b770f0b1cea4f99123804ebcb2b10b1e5436b3f1f49ea"
    sha256 cellar: :any,                 arm64_sonoma:  "5ec98d78eecdb0766dc68ac1350562c14dee447ae6ae1d664b8d22486f46cf6a"
    sha256 cellar: :any,                 sonoma:        "e63a9dfd5c1f01d7b22ba846dc8f1fe7c95080f188bed76d02acb31ed5ab0eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "199a038d63b5e75286b8f1c28d991aed2f729ffb7185ef8c4a4b8a48cd825c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539c2cefd4b992ecb09274f59cfebab58b6ca2d907f1d455fa1c411aa08b2bfb"
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
