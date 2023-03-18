class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "81c28eba10305a998e5bbe3d8e5b0644dc253a47b702c85be521193970b1e057"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35769a6425b81eb13c8726d62eed2cc5821999a1decc72f49731a50de0a41211"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4df3534c5e9c261dcd0c941d17eeeb6a9d45bbeda8b19deaaf5c3113937c2b8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebaa30b38c3ee65bbb737cab44a080ef856ae3dd0d5fbea4748e8a30a4dbebb"
    sha256 cellar: :any_skip_relocation, ventura:        "e576e61b86c91bd1d9e2a255ce6868cd5d830e58ebe12eff1d97a11f4ee7fe3c"
    sha256 cellar: :any_skip_relocation, monterey:       "bfa8f18b4eb9cbd4b3642dac7549c103f6aef13672aa9e83639423d9014a0132"
    sha256 cellar: :any_skip_relocation, big_sur:        "b35103f05a7e45aaef1f8fb7a3a9cc3c7f696cfb08e86449a6d6a345f97644f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b6c3fcb9f24dad1e106acc913d175fd44a8a9cccc3d3bcedf266b92f8b01264"
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
