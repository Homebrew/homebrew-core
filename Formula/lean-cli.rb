class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.25.1.tar.gz"
  sha256 "e3259d004c5d482d3b39fceb86d5d2e1587d79630c3d5d78a4ccfb18d429d07d"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b610efe27d66369078763869fabde41a15c5d45f78c78a32a6f865710e9bb947"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f4a75068991a851e1e465dd43279a431a5d978b526f2460ed5f5a224f508b3b"
    sha256 cellar: :any_skip_relocation, catalina:      "46a6f9bbee5c92fc84c9a05264969ac2a82245e7d7097829793650c6a820edb7"
    sha256 cellar: :any_skip_relocation, mojave:        "b1784a55bda557e43fab859d9093513b6967c253895218fd47250b1555b5b606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d2dceed99693f629aaa06389f0efa0fa8a40be5b1ec77b21f9be368d9bf897"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-s -w -X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please log in first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
