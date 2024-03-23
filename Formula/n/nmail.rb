class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://github.com/d99kris/nmail/archive/refs/tags/v4.54.tar.gz"
  sha256 "e91880119a07f4095970b1a5bed8fb42300d233f9810eb34c8a0c4c25da4a836"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eced1442265c7826987538c99339f27c600a523e56af4526336b7c5777dc0834"
    sha256 cellar: :any,                 arm64_ventura:  "610a1013e5ffeaf0d201058ef18e4b9f6e37004d06cd36867217bfc18d9b5c9f"
    sha256 cellar: :any,                 arm64_monterey: "10deb399499bd6371e3ec62e8a653708fbdaa3a34c25b40a6a582197f16c4c90"
    sha256 cellar: :any,                 sonoma:         "2575b7705af183931dcc8a83d4b7a43ad1aa09ca03a6830c166bdf1ee65b37e3"
    sha256 cellar: :any,                 ventura:        "30c24a45b0d084864244ada7e4a09099dfb810d24cdc55f71087ceb7b8e18fdc"
    sha256 cellar: :any,                 monterey:       "6b6a0acd4bc7c656ea343a96c87aacbcbadbfc9a03cc2ec4376b9eea05fca4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea2f684117129690b899e8a8554dfa166cae16fb71edda5ee2deba726655a8f"
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
