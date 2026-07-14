class Crw < Formula
  desc "Web scraper for AI agents: scrape any URL to markdown in one command"
  homepage "https://github.com/us/crw"
  url "https://github.com/us/crw/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "859b61750ae9d587105a120924c1df99e626d23ae2fafc42421d2e215a632195"
  license "AGPL-3.0-only"
  head "https://github.com/us/crw.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/crw-cli")
  end

  test do
    assert_match "crw #{version}", shell_output("#{bin}/crw --version")

    # Scrape over HTTP without reaching the public internet: crw serves its own
    # REST API, then scrapes that endpoint through the full fetch/extract path.
    port = free_port
    pid = spawn bin/"crw", "serve", "--port", port.to_s
    sleep 5

    output = shell_output("#{bin}/crw scrape http://127.0.0.1:#{port}/health --format text")
    assert_match "\"status\":\"ok\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
