class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.1.16.tar.gz"
  sha256 "d0c9063521264acc73f70ef66cbc8830015df60395ca463d35518313ad7e8c61"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d653464563c657bfc1e80da2f845c7a5391d02295abb953b12b0e3067ca9211e"
    sha256 cellar: :any,                 arm64_sonoma:  "f9fa74005eb1d0af3d7faffd46edd571c4311aa8098eb0665fcd9b2e401ad19d"
    sha256 cellar: :any,                 arm64_ventura: "dfcfdbb039fecbbb08eb7277afc65111adce697bc37995972d4a003297028cfb"
    sha256 cellar: :any,                 sonoma:        "c5e8e7611405e1ba684844fe593d0cae96c63c44b646fdcf3b25096a4c01da30"
    sha256 cellar: :any,                 ventura:       "d8f7596bbb987a1078d794b4cb79163dc5a2cff6e3bdc721cdeb2c8ffa562ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdbfea8f0f2ba09f73cece1da29ce85af4301fe65f6872e2e99c1b0947d73708"
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
