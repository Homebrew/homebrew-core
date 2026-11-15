class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "6c1f227ed9cb60e5aad9bce3b383c3e8b69bd76e35ea51992cf4cd25a5f81d01"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b8ef9d38a88de5f7ee16d7457f05349bc4e68442cb171d963a6e9154de85d31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "199a2aefecbb94a5dfa8bf0a988403872d1359028da4fc9f818c2dcf4a8c3196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e57de9087f91c161eac14f668f7fcf2e6376bcb1efb6ff6b7ec51b7f07e75b5"
    sha256 cellar: :any,                 arm64_linux:       "86c125816d85c736efbe962ee73ffdd278992c4f030b3dd11c9be1c21cc29eb1"
    sha256 cellar: :any,                 x86_64_linux:      "4168a5d77cbde56270369668b774f453c821c2e6eb675f8c35d3bf9c62286306"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  # Test binds and queries a local fakecloud server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    port = free_port
    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    begin
      sleep 3
      output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
      assert_match "ok", output.downcase
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
