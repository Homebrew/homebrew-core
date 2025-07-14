class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/1.3.3.tar.gz"
  sha256 "9b35497a457a205252d16e27611cae919c19871b2edf5a4d61928a2eb216baaf"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f3a92c4ed0ad8e5e0bab77af454863a27a1c657fe7fe87816c2839208fc1f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6987125fcf426713e1bd373cd336ca06a93cbcaa1fb66dcb7731c78f75a1c082"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d84cac1e3bc9e486b84ca8951c4ffecfdbad042d32a7ad8bf16605c0912a980"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b18045b11c4706910dcf03cc5a31c1c240d25c6def10c68543f1d19619e22c4"
    sha256 cellar: :any_skip_relocation, ventura:       "0292cf725519065ea2ce78506d356cd5e6ea451386365e0c01067a61e3c4a234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3bdd2b0ee320cec205ad3ce04e486ef307250d5d5fc2368cf702429b73d073f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097da7ff3dd7914e004f6a3ec7ce9edb4dee07fc865644bae238c70e99b72a2f"
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
