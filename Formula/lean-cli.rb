class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.0.2.tar.gz"
  sha256 "4d844ee3a216da8c2aa720adb936d8364280439f9839f8cd6eca59d91321f742"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5b45c5844013bff570daa151a887169d2372fcc6f5c9c7485699319a6e7c95e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8841e891aa32691f045605c1f2b6f5575c9385a12a18b24972599fc2ce4273de"
    sha256 cellar: :any_skip_relocation, monterey:       "264cf235fff9973ad9ab3c65fc98601e0150822677e2baa370e623a4cea3deac"
    sha256 cellar: :any_skip_relocation, big_sur:        "e22af123feebef39e979c855573549e2ead53719076e13beb3814204bd7f2ae2"
    sha256 cellar: :any_skip_relocation, catalina:       "cbfd78697ad3acaeaa07d0ce96b8bb8dd801d9caf1e88b79b8a84bac11ae15c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50699b68f8cd4adc66f438591ff8dc3fa1d2912fa126167ccd4d6808783d2e9f"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Invalid access token.", shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
  end
end
