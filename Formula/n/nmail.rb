class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v4.67.tar.gz"
  sha256 "e081a0b1da4be25dc0e09a676c472f84d57639be5bd88b7aac6af60f0ea49f12"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97c9d30d5ed64031e65fd92bdf89db3c9bd8230b42aa01726837c72b50ca360b"
    sha256 cellar: :any,                 arm64_ventura:  "206e2e5b64ce955b20f93091c06dbc01af51aac9295b28d985305c738f38dcf4"
    sha256 cellar: :any,                 arm64_monterey: "966e491805514e0459be70572004f85eb8d8826d31f841f0748cc32fcee65aee"
    sha256 cellar: :any,                 sonoma:         "71daa1e4b8c388a76520fb2f8ee3c3d054fab7f9122db5bde8e3869e34b1648b"
    sha256 cellar: :any,                 ventura:        "c17dd2cc2247e7dad177952721be8058db343a72d4d3bd09f534a936d9e8f42e"
    sha256 cellar: :any,                 monterey:       "4b35db34615d85675e45ca9d9c5b77737ec217e1ddd3eb4c714a2f77082bb0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d975dfcf7a74498a2b24f9bf761b1201386c8a83df445c91fd1dda893f2e89"
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
  uses_from_macos "zlib"

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
