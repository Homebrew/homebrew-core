class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.3.5.tar.gz"
  sha256 "071abc7c9c1d5a26616410872d4f7310cd00416f8da0860e1f368ca642ccc025"
  license "MIT"
  revision 2
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "520368fc89abfe81011deb72529d5f200d8c63651e53a223309fa249b5f110f1"
    sha256 cellar: :any,                 arm64_sonoma:  "1f4a5feb746ec6a74db6b57f345ec825f3203477c73fb95c7019101ab0cb5890"
    sha256 cellar: :any,                 arm64_ventura: "b3717d399c95e7cef987e3612e45d39cb22c6f432468ef9739bf794758651cdf"
    sha256 cellar: :any,                 sonoma:        "0ce46c6ae5f1d53d55bf2a13f4d6ec9a419d044a260d8cbd59cab92ecabb9bc5"
    sha256 cellar: :any,                 ventura:       "d26fa6daaa44b82ef0a9e70a19f5c9008c20c45b2b89f9c4c85147a5449e81d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919be579ee770f9720a2b64f671c07efaebe081ee420d071aed68eaeaeb37f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34156b51cd959e3b671ffdcf3b933a9ee2d83d24f9dc89ae6eb8390425bfd5f"
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
