class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.29.0.tar.gz"
  sha256 "f9eed6fdf6f0e436b481d9f882461bd9e0aed78bdbf77a61b99a9cf66875e549"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e726aa3c5c41560a396bd237a7a26c9e4b37644a2f82cc5f3e767af45965516b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4266004c6fea9405b7b081d236f0d55ea5cec6954c116ffecdcf897a812fc23a"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5600a53dbdbdff2072ca0541a9d5e577883c9dfe9d6f1c7663cc9d910255a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "744fae9309a5a24b76ee7aa3487325d74c09429cca9417a1f3be6e393796306f"
    sha256 cellar: :any_skip_relocation, catalina:       "611326e242ff864d21c905f1f43461e4e577f19c9e6dd5fe99cd3bfa65b32d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb73ba97a0173919ca520d9f8c2579d4d8e04ae210853ffdd4d161638b8b17d"
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
