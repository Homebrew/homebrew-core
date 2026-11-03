class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "af2a1d3fd37c472c0692b46fd0fdfd74a43d39ef12a677dbfeaf9e634d83b140"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b47ceb2e692bdea7d7cdc9cc62e73f2aa694a157a107ee34ba624a577548974"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b47ceb2e692bdea7d7cdc9cc62e73f2aa694a157a107ee34ba624a577548974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b47ceb2e692bdea7d7cdc9cc62e73f2aa694a157a107ee34ba624a577548974"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb9bd0253a50f77c3d8939de970e66e0acc83b8538f541a9292e1ab1cbd56a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "93fae758d97caa24da658e79a1c30620680607d32c1d7879d8d0395329cd5c5c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/1broseidon/ketch/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ketch", shell_parameter_format: :cobra)
  end

  test do
    ENV["KETCH_NO_UPDATE_NOTIFIER"] = "1"
    html = <<~HTML
      <html>
        <head><title>Ketch extraction test</title></head>
      </html>
    HTML
    result = JSON.parse(pipe_output("#{bin}/ketch extract --json", html, 0))
    assert_equal "Ketch extraction test", result.fetch("title")
    assert_match version.to_s, shell_output("#{bin}/ketch --version")
  end
end
