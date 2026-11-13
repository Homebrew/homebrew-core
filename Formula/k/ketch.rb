class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "026b5022403fb34860074cc3951ee4566f7edaa94d63be58f72e844a6cf74a98"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e09201c2838c648bd48136dd8100bac451b2b57eca976122b0839c6a9158192c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e09201c2838c648bd48136dd8100bac451b2b57eca976122b0839c6a9158192c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e09201c2838c648bd48136dd8100bac451b2b57eca976122b0839c6a9158192c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "000856035d83cbdab5eb3c95b43db71899d23c5b8eb1af5556dd12daf79a8a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0a61d870acbd2df779ce16e97649345248d74778426ce1e02862f1a9dd250f01"
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
