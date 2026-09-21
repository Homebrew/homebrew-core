class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.37.tar.gz"
  sha256 "725fdbf4c14d87eb7e926aebd9b116f540dca812bea02e73078070156d986ad4"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d51c4b4453294f27462f19dae8109490a0e16b37f3b24b07ca139dc68045d738"
    sha256 cellar: :any, arm64_tahoe:       "2c57f670eefcbe0691223aa44d6fcbe955937f37ad04a82871bc596c6798c29d"
    sha256 cellar: :any, arm64_sequoia:     "a26541bcb100a243376888e26df5218ea5a85d42e1537bc20c46e56b71303809"
    sha256 cellar: :any, arm64_sonoma:      "89f65299bb16b80c5dda5cdd951d2bd1fde35a8be9e539671358a38fa06a4f22"
    sha256 cellar: :any, arm64_linux:       "ed34e64a979a001be413a302f613f95953f803dbf0c66543381969a74641aa94"
    sha256 cellar: :any, x86_64_linux:      "999cf289e6b6f111159297032f8e536ac37ff2c5a07cc74d6b8d75ce27f3b449"
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
