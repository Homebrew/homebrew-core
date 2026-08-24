class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.10.tar.gz"
  sha256 "72376f92ee00602ba8b15035eef3339722f790bfe00c2e9c8299cdddcff0ef1e"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4441c54edc3f57fcb4ca7a7c1b797416102b7d9b394313dfbfdc4768e882ce0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f49bd5618921c6df02f8181452b58d612507b82984feb49caa98523293f358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a9d6908b1cc8b6abce2dbd85279f9a428c308aa81404006c27b568e473aa42"
    sha256 cellar: :any_skip_relocation, sonoma:        "7904583b80247bf0e16dd81a70fdd8c09eed3ba18d1faa9236d6f9008878aa7c"
    sha256 cellar: :any,                 arm64_linux:   "68a68cb0dca6c7498427fafeceb5878ee606db1683e8e831bd8bfd929b92bba3"
    sha256 cellar: :any,                 x86_64_linux:  "8c42310106caed3bf30893716a1771ae718f711afac8bb84813f412cbea28923"
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
