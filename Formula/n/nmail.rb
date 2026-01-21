class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.9.2.tar.gz"
  sha256 "349217973622ee7d3d3b1ad6e7108efa4926d0f9324839b04a8d22f52e3e6a8d"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46b3ef34316bbd33256de94bf836e737ac6d1bec2c41e09a4e3f2bcc02071b91"
    sha256 cellar: :any,                 arm64_sequoia: "29367f33eab52385d437e11234c6a706b2f9b6d2265fbb7e3e4fece95e99dd1e"
    sha256 cellar: :any,                 arm64_sonoma:  "054bd0f632586cf4c82c3920db190db6c049d350d6f27456b03ebef703b5934e"
    sha256 cellar: :any,                 sonoma:        "67cb8f33fbf8b77a83eaf0d5a79d0ad0ca07535f271a24dce8430a67c4b3123a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "790c50dc346004a73cddf5cf8ebd4d50084af3646920cd45a18f300d0d61bafa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca405942305b204a1c228c66408f9b48ccd9a49a2edb53dddc2cd8034336eec3"
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
