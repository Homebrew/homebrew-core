class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.16.4.tar.gz"
  sha256 "5e563291964d60d4c73aef6e1d7067958960be4a9e99c1c3735dde82c5166dbe"
  license "MIT"
  revision 1
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "10789ed5614d01fcd29423b93acf1b473c9c57366f15afe25a5aee8c658c5fa3"
    sha256 cellar: :any, arm64_tahoe:       "84989ab2f6cb26044327e54a509273f457df09ccd2129be2fd3c0192dabfa871"
    sha256 cellar: :any, arm64_sequoia:     "4018a320aebe146c692b11cbd500932a76700e1e50f71b4642b274e606e26f9a"
    sha256 cellar: :any, arm64_linux:       "3fb9583c3b8db41a81e4db59e14b65ba8a48d7af2785436df8e1fe70ab0f4a0f"
    sha256 cellar: :any, x86_64_linux:      "b5af6ccd52462c97204849fb88bd0e85cad39cbb48fd3adeb89516b43717c402"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@4"
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
