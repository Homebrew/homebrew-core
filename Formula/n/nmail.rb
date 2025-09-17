class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.6.3.tar.gz"
  sha256 "687baa35f57ede234e55daba68850dd4b80a13ed641c8df08c63cd2510dfc1a2"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d7d2250b80477f7003461b00257002662ff1bdd01527155e9842aaf46d04f94"
    sha256 cellar: :any,                 arm64_sequoia: "99c507743835a8d067d73daa00b96f90710b9a0dc46c59c403b4b5cf5c4d84c8"
    sha256 cellar: :any,                 arm64_sonoma:  "7b8e9378d963846cd384ad8a7badb23362e8e1bca930f30a52862ebfe03d3fab"
    sha256 cellar: :any,                 arm64_ventura: "a8b7bbcfd465c9784f4310625591778307675d5c9d6e67b98d0f1e5d5ba3f626"
    sha256 cellar: :any,                 sonoma:        "866f10f147d3a31a0b5d845153c3088a02ca27d8ca328d40839e99d836d7dfbe"
    sha256 cellar: :any,                 ventura:       "7e2c41730a3b75e11ec9dd17eb5ec95981756e803b6296cfa0ca6eae225e4306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a75b837cf75e0f5b471cd75d571af0430538f4539ca706ae693edd80724625fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeebbb04dd737d1b622d85e2b6464402a98f2de180de5d4d398ad4aa48938b14"
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
