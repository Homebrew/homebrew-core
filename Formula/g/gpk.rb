class Gpk < Formula
  desc "TUI and CLI that unifies every package manager on the system"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "9dcdd0b102d8f5ae167c8215c9f730f85c0a712a7bb512d78fabea47f6616b14"
  license "GPL-3.0-or-later"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83123d0b2b375b854837cd74cc570c0e6a5dab1358dcdb56b9ac330fcb84d47a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83123d0b2b375b854837cd74cc570c0e6a5dab1358dcdb56b9ac330fcb84d47a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83123d0b2b375b854837cd74cc570c0e6a5dab1358dcdb56b9ac330fcb84d47a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eaebe1f60b4bee89dd544177555ba2d9b74f5260ae949bfe7eed06aaa7c9999"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5565f75bdff9cd5c21234bc6acb4976320802fdea3a30c4ea2956949fa7ea6"
    sha256 cellar: :any,                 x86_64_linux:  "88c1dbb2e605ab2314d41b686dcfb649c3928e9dccd24affb479c08d58ea4e8e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}", tags: "noselfupdate"), "./cmd/gpk"
    generate_completions_from_executable(bin/"gpk", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpk --version")

    # gpk must enumerate the real Homebrew installation it was just installed into.
    require "json"
    listed = JSON.parse(shell_output("#{bin}/gpk list --json --manager brew --quiet"))
    assert_equal 1, listed["schema"]
    assert listed["data"].any? { |pkg| pkg["name"] == "gpk" }, "gpk did not find itself via brew"

    # gpk must recognise the Homebrew keg that owns its binary rather than self-updating.
    assert_match "brew upgrade gpk", shell_output("#{bin}/gpk update 2>&1", 1)
  end
end
