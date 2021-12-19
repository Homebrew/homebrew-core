class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.29.1.tar.gz"
  sha256 "4729760a59d8390c615457d0a01ee38ff8f1055e9fa8645d5763d878c8239d74"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297e5b3365b8b9962c9043f83187d134f1dfbde6a5e9bf701ffdf930a04aef34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93f973a8f75638ba51473f543a9a6df01072e9d6a83f2565d4afb0fe4dbb31b1"
    sha256 cellar: :any_skip_relocation, monterey:       "0ae987771c7232f15febd496216f1a6c58c9a480ce07177021dfe0f13ccebd34"
    sha256 cellar: :any_skip_relocation, big_sur:        "2569f335f70633cf3b4934985b28a75c8901ea7d1bcee18f6c72dc17121db48b"
    sha256 cellar: :any_skip_relocation, catalina:       "28f91cea2e135ad326b1809dc847830cffb7c1817cf5de08dd9f9a17f0e5e38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43cc33d0a8b9c99482403d3ec6ed07d8ac0dacd5943d18636f51022edc7c4a77"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please log in first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
