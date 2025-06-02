class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/1.3.1.tar.gz"
  sha256 "bee7a5989e557d366aec1e2dc005e269026a2f46a097e321a721a99e70570412"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b98b68a0735f52c6425ef1e005c537980c74c7444d0fbb58d8239c2fc88c3c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92734901edf8f4af39d57b6216dacf95fe7c37928fa91cc45ee529d66b460145"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8657f0c6555b343769c7ff422daf8ec84e748fb0409d764778b763cb274367cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2467335cfe7aa1d10e8649225e63f20a96f1d1d21949f356ca39755dd5a9d261"
    sha256 cellar: :any_skip_relocation, ventura:       "21783fa27909b3445f8cf5e52fa77e51ccbdf18734138bbd4dd1e46fbbdd789f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ea696a97bc86e90a64519b9add26715f551cb9b60fa1da821954b2575cbbb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a2b18ef89d83e7fbbec0c1ec49920b22559563b1c40260990fda44e6a7d3c3"
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
