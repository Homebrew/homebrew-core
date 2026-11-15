class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "79b96e141c55cc859e3bd0210da14493f2a112188fcf5d17d0b83c8c869c816c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59de5b15f1111ca4664f5b9fa7cf60bab9fda42e6e63658e1f720460679866eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "72223cb16ed1549be5dffa08181c59d3e066180a1f901b607f652575c40c427f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17c954c9aa5d4974f55fcd83cc9ed0fb40aceaa2066f009f25e21642d030be98"
    sha256 cellar: :any,                 arm64_linux:       "d3fc120bea8d030d2bad977f2b9fe41f8a2e0ba5c59c049dd33ccd0b73a223ca"
    sha256 cellar: :any,                 x86_64_linux:      "d90582bcb73ed6a088b989d89d175a0c80d25346602730ccf71ae5d792eaa1f3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  # Test installs a package from the npm registry
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
