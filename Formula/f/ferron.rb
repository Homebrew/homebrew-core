class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/1.3.4.tar.gz"
  sha256 "7bbfc6f804c742c70b29a8494545dfc589602b1ce7b3bc41e48ab8964905d54b"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3aed53ba09d52ab0822e5fcdde37806b03003ac0aa7b9375e58c6ca0944e56d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5ccdca2d73c4f3137b0426103f71dcaebea967d914abf376a0ac4bc906110b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "777930ad82d7043e80be237ba61faa18ac2b43ef17e201060cb686c23b991c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa9d9acd909295d274189a92a232b1b3056491e80fe07df982923142ea6349c"
    sha256 cellar: :any_skip_relocation, ventura:       "dc3735fd11e0a676aca4474429ca5c787c6331f7743d1e407242211a2ad3f50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "286e3f7be23017d1980e0a099b56c29aa5459afb0b453568e3116911b4779e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e3e2e9e9cdf42d07a2f073bb76f13b78e6b733ef817c9f98e5456c1d2ffb51"
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
