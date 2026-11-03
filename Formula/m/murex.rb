class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v7.4.1116.tar.gz"
  sha256 "7589791f8743336f904946b5fefcd27f58e7c2367757d629059145e98ab2f372"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97e8187cfaa5895075ce2ed2f527befaebaa5b7851b8eb5ab05634011311687b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97e8187cfaa5895075ce2ed2f527befaebaa5b7851b8eb5ab05634011311687b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97e8187cfaa5895075ce2ed2f527befaebaa5b7851b8eb5ab05634011311687b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b65eea8106bee33d6e4a01dccc705a8e3becd974bf46971b534bb71ed973ab61"
    sha256 cellar: :any,                 x86_64_linux:      "68a749c2bf170bbaf03cee7af7b19c34d3dc693fb8931164d81acf9846335064"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
