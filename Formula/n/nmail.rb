class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v5.12.6.tar.gz"
  sha256 "d68dc58ad6eacaeb4e357021ef84365101436bc2f77af50b620a75f5aa02ce2f"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9c2c868e7751becd93c378997d3a176f511dedd07f220ebd6bcbe58c34e9e65"
    sha256 cellar: :any,                 arm64_sequoia: "fef6f541240ee54973579ae8b1677d3d92648e38783d318a39491ac01b3aa34f"
    sha256 cellar: :any,                 arm64_sonoma:  "119278c6e74cfb33d6d91af96c87d20c6074fd4dda231ab5c6fe82921258136e"
    sha256 cellar: :any,                 sonoma:        "0d9179053db2765e1bcccecefc8b349b102ab0776b2e0ff43a32a35dded012ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc51627e3af0097ce501d79f6776e0355ed6793471088b0e97b3289b2c774bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "900b111b3aeac466662730872fb8617b0fb3d491deb9e6079417b12b93ea7a20"
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
