class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://github.com/austin-weeks/miasma/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "9ac107dfa0fdebffb68a8f7fa606534ff0984bcbf8e6fce24c26c515a4dbab00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2776d6bf85cffeccf9fb4fcd8ddc218521fc5826032b379c0f1d9d3eac8ffb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f63ecde6fb48d1103639227fda593c9d8330e4f29b0a88a0f0e7b5ad0ce083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d39b7b359b80ee5be4d5767851380ec5320a469e3542323c215671917b2c3c3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3fa6d330c68d219d64ee60d121dfd711cb7906ceaa7879767c50b8f135dd87d"
    sha256 cellar: :any,                 arm64_linux:   "a3184c82e017c5a32c2fe2c430a970f74ba8bd250488e463090e4969aaf8f758"
    sha256 cellar: :any,                 x86_64_linux:  "e89dc7df4c352152e4fb420f15720a58db9ac8ef9dd636dbfe7d137b2601da80"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
