class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "a10b93e7e6f003e78860d9179f74d02fb40fc58e6f8954aa12d9761b8b34e946"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bce13af8b94effa79d439b84773150b2beaeba0b8398a550a45afd5a0876080"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bce13af8b94effa79d439b84773150b2beaeba0b8398a550a45afd5a0876080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bce13af8b94effa79d439b84773150b2beaeba0b8398a550a45afd5a0876080"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6c08ee7d9b454492f1bdf9ba6b1416b6804a6dad6e9d06bf15e4f3a6e41727f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bab9d30191112079fd71181a0a5cd7961574a71d57bef6bccbac613efeb67b91"
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
