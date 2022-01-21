class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "bf513e7563f06b0faefb78062992644eaaf464752cf4875bf8fdfb774d38b109"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd0567e0567ac1f095de2304e202dd12b9638d3ac0ecacab085ce588408e1cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f586bc9c9cec5be77d08aa61063369111caf61ec192e09e55001c22313de9b7"
    sha256 cellar: :any_skip_relocation, monterey:       "088864403d7bbf965e5c58f65f9586b6309c1b2b49ecafaae786c7631931e4de"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6b436c21bef32e464a6fef79dcb3469fcdc487eb37495b2f9b5f61ce3b8092e"
    sha256 cellar: :any_skip_relocation, catalina:       "51650a8559d706bb6dfb911c17c04da0c6839fe0dafaf1af18ec03eb20b5d5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59655d9cd47380815c93fdb6d43f9620bda0343797aca4c566ddcefbba1a84c7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    bash_output = Utils.safe_popen_read(bin/"cilium", "completion", "bash")
    (bash_completion/"cilium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cilium", "completion", "zsh")
    (zsh_completion/"_cilium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cilium", "completion", "fish")
    (fish_completion/"cilium.fish").write fish_output
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
