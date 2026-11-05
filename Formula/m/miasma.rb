class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://github.com/austin-weeks/miasma/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "073a413fd19b695fd81b78c64e8463bc616a6c58e50e40da03e0f02d99f62a6a"
  license "GPL-3.0-or-later"
  head "https://github.com/austin-weeks/miasma.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88c37e192aec909ae1ebca7ff73f7bda6a10e3f253858f49c489a5f61b5142d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74756db53c6d2fcec363a9bb3d81ca3b6fd1ffdc38d64d42d3c6db7eb69d86c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b85721569acd61cf9cb20a6f477b51325d970f4ff53f3d7a985a4813e7270342"
    sha256 cellar: :any,                 arm64_linux:       "90ced09927460e39d1e478c095aa187d6a35abd0fdfc94c53445070bf3a51e00"
    sha256 cellar: :any,                 x86_64_linux:      "ac0df4da53290ef5b89005298d59d75fee16d13eb89767de51c57b8ee207004f"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
