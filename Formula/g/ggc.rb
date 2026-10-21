class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.6.tar.gz"
  sha256 "b524691a42dbb5fe06bcadfca05d18bd69ce472ca9a2116181b727a1a5cb0158"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84e714fdb673f9c9d4ce1c298c7f7802e68f0d77661a2252c350c16aef215938"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84e714fdb673f9c9d4ce1c298c7f7802e68f0d77661a2252c350c16aef215938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84e714fdb673f9c9d4ce1c298c7f7802e68f0d77661a2252c350c16aef215938"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69d0dc31becbd4eca6fa8fccaae1fde2c3295db66c3744f16b2b5eb9c9f9656e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de86a67ee5e79727dd13289380ade7ef0f4267e174154e3f87dc628040997c92"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
