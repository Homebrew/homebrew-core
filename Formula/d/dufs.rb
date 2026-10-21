class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "bab9d4fa1654adc6c88523b61bb8697f575334248cf554282e1f87e2329c0569"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6baa9d5e40b56599699c831aa4adc697219ab735584104bfe715ffad07a7ea3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca0fc8ecbf366d49cdfdbc5015005a9de1b209d6c57a271c86e2b08499033ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ecc87a1101986de063f156f6c5bfec989694ac966d82ab0cc993e8556d4eca8f"
    sha256 cellar: :any,                 arm64_linux:       "1e9d181d9bed62aa9025d92153f2df1b1f071e452cf5868feb7f086945a6c10a"
    sha256 cellar: :any,                 x86_64_linux:      "42511a2cd5c3ff1ee9eeacc4fd028f1ebbf76f89c638dca687efd2ff0ade7d8f"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = spawn bin/"dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s

    begin
      sleep 2
      read = (bin/"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}/dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
