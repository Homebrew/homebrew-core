class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.7.3.tar.gz"
  sha256 "d2d1beae33e9f1cbbdc45a1e9fa97bdb414c66a3e6227adf440604e2a040a39c"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3d71a6b47462cb5aa2674d9e295a8c3e8a9d63be213584ea8e04fed170b425a"
    sha256 cellar: :any,                 arm64_sequoia: "c44566445971cca9cfa6b0b9da48003b4f0b16853643d04ecac31b0f2e565d77"
    sha256 cellar: :any,                 arm64_sonoma:  "9a6b8ead0d9602ac0814d89b0b887c7a0deb4ff88c3cda4dcc453c0f8a1cd93d"
    sha256 cellar: :any,                 sonoma:        "bfb7d39aaf383bba2be25173a7200e3ed8d080cb845924a3fe148986af58b751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28b04fe86aac501e36b2a28ac0dda83bee5d2059497e3175f3feb2b96d15ce3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d72151dc0952046508c533f82040698c416cda5fb48d2e09f13cb2be48ba0054"
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
