class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://github.com/austin-weeks/miasma/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e45695ee6bc4675673bd9aa94923b18908f425b22ea0da59a4d070932253032f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d83e2e4d1a5b52b7e75876f7fb6bf5a9ba4acc4d6026f39c782cf9e679d5d161"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e7dd5e091148d8652f70fd560d907da9fe65f2ff8e4915a7c131b70a86f0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98aa1ad3473e08d00c6511abb11bb0858620abb54c68b7ebae01b0fc2ffccc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bad4ae62eb323a3e6eacef3dd9ab8425f9ae12c0488dac5f36f09c67d6a3265a"
    sha256 cellar: :any,                 arm64_linux:   "95b390ef40aa53fba425e4af7ad9ddad975015210597a97f959214c96f430a02"
    sha256 cellar: :any,                 x86_64_linux:  "c62dfc5878fbecd32a076e5b38a0047a1e4ae0803ff73028f832b8a5600a15d4"
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
