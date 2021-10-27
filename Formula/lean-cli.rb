class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.28.0.tar.gz"
  sha256 "172fe20a7a4fae61369c63dd41327a69382f4f181558a1159dc538ddd4aa5892"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bffd6b66d6efb812ba431ce22519de62a35a63096e37d8e5ce5dfd4fc6f98b09"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ea7361fed51d9bd16f8b7613a48d1f77cd39bc0703cefe1aeb0ee163e7ced6c"
    sha256 cellar: :any_skip_relocation, catalina:      "7c21b054cf528020ea9077cf543756f56364494faf02e9315e5d30bb65f2b2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b80c1de4d882716022d9fac778cb09457bd8a2a390e7e49d4a4a4dbf88e48a1f"
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
