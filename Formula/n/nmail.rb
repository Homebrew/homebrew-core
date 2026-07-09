class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.13.7.tar.gz"
  sha256 "c0e0f30275252237959d63a59c0b5920a9514e8ea7abf05c693b8dc43fad0563"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bcf7e2d4e3bb3f3ac21cbc31f0acb80a3405c79e1bee20e4dd65a37a63c22233"
    sha256 cellar: :any, arm64_sequoia: "382fbe02a98bdcb299dc2f7c18e159bfc33d4d278ee23e275a5d83192e81379e"
    sha256 cellar: :any, arm64_sonoma:  "288a90a2393384350c70b05b7c0b272bdc9f9ac53840f98ddebcf52131c71e09"
    sha256 cellar: :any, sonoma:        "db2a31b42ad1151eb4b715b1044b05505def79ee3b3dff594e389efacee05bb6"
    sha256 cellar: :any, arm64_linux:   "0eaac85aeda93d89aac036409ecf9d4992aa174e675ca1192123c61fb478e9aa"
    sha256 cellar: :any, x86_64_linux:  "745b2967e6321f42f16bdfb755bbd2cab4597c99f985472748cbc012f26e2ee3"
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
