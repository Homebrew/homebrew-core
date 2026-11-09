class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.7.tar.gz"
  sha256 "5d016e01d89e255c635e9d5a99d1be07639dc1a58b0b61aee95c34b58eea5eaa"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89a1ebd4aa9da1be1fc0383c3c4d248a6e582cbf025373dcc72ec185bf80dc9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89a1ebd4aa9da1be1fc0383c3c4d248a6e582cbf025373dcc72ec185bf80dc9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89a1ebd4aa9da1be1fc0383c3c4d248a6e582cbf025373dcc72ec185bf80dc9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9138a3d440efa00458c9896bc0b022d75b44df4a014f8178ee55f083239be7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "280a9b1e30d50045c53ff65e8776bf4540c80c55349368a018f71b427ad1e816"
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
