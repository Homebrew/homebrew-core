class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "cfc4d9baf4d0ba3556094795b2cfee43459185ca38e926928046f5be1aba7d7b"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28fbeaf2bd7b63fd47d8e013a8197788bae54cb8b16c6271bdb105fcefe6186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a7dc4aae66cbfc8b102fc9bc588ea4ccbb93da62328e131f6be4a033f799d4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51adef6290b108f8b1b27ab1f1572f63471a7d50276857e268f9ff576d62869b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1cb9baa5e80b00afa959a71b8fe75907ac6d176c93590c060b5cc3265815b9"
    sha256 cellar: :any,                 arm64_linux:   "5ebb319077a854fa90f7e84d94c5e8289108acc4117f9e166f9c4acf5e957a35"
    sha256 cellar: :any,                 x86_64_linux:  "99cd1597b49c5c9e8c63397466e18f6ac8c0fe7d2063e587d393d03ddb6e728c"
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
