class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "4d4732b5600179617370df5269f4f98b953b54026cb30e78b52cf419e9fcfacf"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf7d14302d95633921c86ded399596e5c05a32f3a747ecdeccd71b4697a91313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eb2dcb21712a7687111dd237a1c9c4a3ac2dab24a054bc8bfa38d6d0c2334b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9c2de16662a7089dd9b20d760c1537ef0983502a5aa73fd30ef2cb3b9faf15"
    sha256 cellar: :any_skip_relocation, sonoma:        "af7b7562c055737fdc89ef9b363a67ff0238e0fc63be18838b72ad377ded1d0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "469a8f207659479504d3533a07d6db389b977e2256190d4787cf61fbed383cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37a8db93f9a3bd798911c727c819714ce861f1448d16715d0f70499f90a6ed1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "libcap" => :build
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(json)
      stdin.close

      line = Timeout.timeout(15) { stdout.gets }
      assert_match "\"protocolVersion\":1", line
    ensure
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
