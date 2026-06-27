class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "b3aa032d3608fc18fa418bbb58188b2dbf76cbfc09ee80917135567fcb455568"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fe9b615498d499b3287f93e35ee28674879cad9459b0a19eaeaa4b3ee025c86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c85dafd4f478692a36ebfb717454d613c67d0097b2348e6b168263877ea7a64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13581bc2a991e4144f9c6a9aead87425e4fd8c0e5e4ec075eba1ef56630f5cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9895ebaafbbd003b01657de5d52f65c54d0765d6a900c393413e245b0d4c561"
    sha256 cellar: :any,                 arm64_linux:   "3036b326095a304ba6adc512b8b09853f54beb90ec08866f55ab3d6de1a53c99"
    sha256 cellar: :any,                 x86_64_linux:  "e39398e5ca75487b86356254580bee1ead2929edd05fc2f3b8b97592a269e782"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
