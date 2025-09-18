class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/1.3.5.tar.gz"
  sha256 "f18e33c8a919a5541248676e39491b90c0fa0dcef73ba0ded017476df795dacc"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fcb602e5d00405d0d723012b5b456386003d763b826e1d6cef0b9377bb75b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1222b8597170ae0e8e1a802cdc0be7759d516526fbf66af44784ac7ea4dac0e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc3d493eed9e331b294d1520834a6ff1443bb6aaea8b8f3620c3f2e5a5a48a6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4944aa253d2a09a11048ab777180177e61be015b703ed6270d06484a1e2d4665"
    sha256 cellar: :any_skip_relocation, sonoma:        "e77ab9578c9959c414bb1dd014c42755feb1c3c2ed164cfcd69d542bdc7c3511"
    sha256 cellar: :any_skip_relocation, ventura:       "406793e458c6a9c7aaaccbb3b2421a7dce212c085f2565a37ab74a39cc0fffce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd0684be0fb0a99455d351fe81c6b281b224b39a451fee43c0bef8563d96861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17773611e9d391237b525863e11330b8cad4c887c4332d0e739be964af5f2e2b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>404 Not Found</title>
      </head>
      <body>
          <h1>404 Not Found</h1>
          <p>The requested resource wasn't found. Double-check the URL if entered manually.</p>
      </body>
      </html>
    HTML

    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
