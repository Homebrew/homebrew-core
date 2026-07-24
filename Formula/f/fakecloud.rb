class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "733c7b756591991e6b4ed43a16cb82943888242f2627af910177fe22486fac0b"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cdd0a016eeebd2ca78cc9308eeca20ceb1fe9a982fb0f7bcbd2104938bf23ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a0a91628619efc51404723725a905b77cd4663e1885a6df150a243bab5d38f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c856fb84728d69634e07e21c15ef1854662f4c5d1a1cfe3cc7416346c670f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9864517207c199b97021c093b6a282cb6e1c70cf84b0761a0ed1a7c210e1c696"
    sha256 cellar: :any,                 arm64_linux:   "1f698926cbe84dca87803152c7c0386db6d70335691dce6b6b9262994c299a14"
    sha256 cellar: :any,                 x86_64_linux:  "09c27c748167610a63a50ecfc6132bbcfff9b87cb4a9d894b5dc98f1c07ea8b6"
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
