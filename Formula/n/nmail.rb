class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.3.5.tar.gz"
  sha256 "071abc7c9c1d5a26616410872d4f7310cd00416f8da0860e1f368ca642ccc025"
  license "MIT"
  revision 2
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e72b5c52451568c90d29fbc3c6b62f9e1c5d39ca4b231ee034934c36aa78085"
    sha256 cellar: :any,                 arm64_sonoma:  "81d11f446f22d205340d8710d8b396d868f191be9243debea62fa6889f602ae2"
    sha256 cellar: :any,                 arm64_ventura: "99fbb7162cbd512d0ad904c331c558d03477c272e586abd93bb73acef2ec9198"
    sha256 cellar: :any,                 sonoma:        "dfc51de93f0972a4d15c3afeda9956e5ea3d60b8c82c6d9c8b42be32a3f58cf9"
    sha256 cellar: :any,                 ventura:       "0b3c105b12c2965b5ecd6d4de5771fe721a9dc9895c99f93b95994874891a4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a22770c3730478c2a81197ec336127b1259b8914704337a5600cb92ea86c24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b354d89d63c49fbc07412c4c81becb69cbe78c6bf6b97a861d2e4b957388ad"
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
