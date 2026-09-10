class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "aee5de0d4bb93100f60e8828d24eabd6403c006563c0c4735421a36152f048eb"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

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
        <body>
          <nav>Navigation outside the article</nav>
          <article><h1>Offline extraction</h1><p>Extract this article content.</p></article>
        </body>
      </html>
    HTML
    result = JSON.parse(pipe_output("#{bin}/ketch extract --select article --json", html, 0))
    assert_equal "Ketch extraction test", result.fetch("title")
    assert_match "Offline extraction", result.fetch("markdown")
    assert_match "Extract this article content.", result.fetch("markdown")
    refute_match "Navigation outside the article", result.fetch("markdown")
    assert_match version.to_s, shell_output("#{bin}/ketch --version")
  end
end
