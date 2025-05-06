class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/1.2.0.tar.gz"
  sha256 "20516bf2f2d0617b8e8cd44ae9cecc91ba76fa4b482a6d0683d14700310232ad"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "221abeabcc94ed1973df80f95b534094eaaf7a5c3fecbdff8e3c090e38fbb2f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a2e45a28a4a8e296bd66a198b98f26d2f924a3f016bd620af8851fedbe53f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "449c5b04b63df3a19c529cd8eb23d7d7aaed093f49e54220d82dc29fc720c90b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d611e1b67447065b5de3c370d6179c7e9f8a4aee5bca07c2cbae238901b90cb9"
    sha256 cellar: :any_skip_relocation, ventura:       "d083ac60e7e85d89e76672fb5fbb48c72cde50d93806afb37497a15cd24ca1c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e7277634705d497131dc9e5ecc7089df90cbb8a31fc184a6ca4f8576c6acbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2980abfd1716fe485a4b64a1112d7d0c23b07f92db834baaa388a5f82388624c"
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
