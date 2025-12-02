class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.8.9.tar.gz"
  sha256 "5ae45fa14675d0893cfeebd501f12a8f2dc676afb3e915d251a3ccc8bde47f81"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "baff59d28133eb06f72d9e5c736c3b56d1868885a9e5bfc328ee08c4996d794a"
    sha256 cellar: :any,                 arm64_sequoia: "a42d530aaf160c4770620dd37dac7a3776d06114d5d2cc26d9441780234c2f59"
    sha256 cellar: :any,                 arm64_sonoma:  "1b559f64d3d6cd3ab0abef1ee1403ed437a425d206549d99d45e58e4f8c0da6f"
    sha256 cellar: :any,                 sonoma:        "23d9e7857306ed1ea330cd6460c1c479de6bf2a914ebd57df428801a4e776e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d96022de63d10b2d652fe90b2e4858f0d86a6c9f2d7fb540205fa56b8f72340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1497cb53013dd04c832ad08a116cd0b1526db3f9d330db2123635fbacd3471b2"
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
