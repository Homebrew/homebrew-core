class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.37.tar.gz"
  sha256 "725fdbf4c14d87eb7e926aebd9b116f540dca812bea02e73078070156d986ad4"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c085a1531896f6539db6f83e6bd691187933d105f2706866b4873eecc693e90"
    sha256 cellar: :any, arm64_sequoia: "2742670f0ccd78da167aee8a3bb54d31fde6da625a6a4918ea5accea745c47e2"
    sha256 cellar: :any, arm64_sonoma:  "e0d7d367e2050be474a00b29ada76a7488836a1ad7ebd1245a73a886b894065e"
    sha256 cellar: :any, sonoma:        "e88480402758470672d11ed32ac885d47e63cbd1d859f0f66d0af8e2ae549f12"
    sha256 cellar: :any, arm64_linux:   "449cfc643d7f9dc8f350c5dee1e6833422057cb1a955de213e11602d5da4747f"
    sha256 cellar: :any, x86_64_linux:  "ffcdf22a4e0616b5d88321e3ed9592510414333b4b5bb0de6d9334a14f6b11dd"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    # On macOS `_XOPEN_SOURCE` masks cfmakeraw() / SIGWINCH; override FEATURECFLAGS.
    featureflags = "-D_DEFAULT_SOURCE -D_BSD_SOURCE"
    featureflags << " -D_DARWIN_C_SOURCE" if OS.mac?

    system "make", "FEATURECFLAGS=#{featureflags}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "[INFO] Okay... Here we go", File.read("test")
  end
end
