class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.14.tar.gz"
  sha256 "9193a090f234641053a0c023c2165ede937328fb53133e2b0f5d842d70e896c9"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36e845716799f33a593a00926cda845cef27dab8ed872256bff34867d71e2d3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a55e5bb9a7004a70190be8d6f99db13eff4e1cb3f5f9fc651dddbbc490c9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4783a94a7fbc9b660b5054ffd75355c0bced150b3126f5bccc76bf27b1368b2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "22586e0f6c420341c1f7335743552f9bd8a0dc6050c5e8ca96c5ce1b15f97c84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a289777c49a36d032d94fc2beaaa32cde68463094a92e219e6e09d8173bac6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7f00f25de182551e239855a7152d26ae4dee096fa17dccc4a6f5f6fe04d359"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
