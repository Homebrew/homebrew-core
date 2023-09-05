class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "2ecd7dd45b30c9797fe96399fe58285080fee60578c61f1bb68d8b5aa38abafb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01a59a7c2bbd421a83bbadee8bf5db1f55c95bc40c4014ea4473bd052aef80f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71ce80d1f9c747b67558e8b368f5d23ec54d4ef0b2ab22c597bd1562993411de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd5d32c4ec6564cbad969189a2f31e21c139284ad276bc80ca074ae13719bb80"
    sha256 cellar: :any_skip_relocation, ventura:        "7b4466cc7e33d066a4b50b1e3d52ef6b8c597bbbad01cfeb0bcf01bd471ade0b"
    sha256 cellar: :any_skip_relocation, monterey:       "4afa3accb14f9cf3cb099b0a2457a2cffa8cfb7c9940a0a8ee07a0e81236a509"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0e704feff267f17233c535fadf4f82b7a9bc3cf2930f7fc794552a7a0c95968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d568720bc0a16d1cbd9ef8307798f26731bb70a7bcbafd4febfb14ca0d156d09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}/dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
