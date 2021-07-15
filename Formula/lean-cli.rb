class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.25.0.tar.gz"
  sha256 "b70a1a9fe221582922312c041a4946ca2f3eb0267079ff88e33aa22c9b61875a"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "002fd0f9bea63513428f676744b56459609cfa1e09067ae015efc28582b99be5"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1fda181c01d5c725c0c828af24bac3df4f51b6c2e88eca52e549adbca9c1c89"
    sha256 cellar: :any_skip_relocation, catalina:      "82b875c2a16ef69e0b9b795b3ad3152f02821e31d51544a1b41e5afc6c816832"
    sha256 cellar: :any_skip_relocation, mojave:        "c96575eaf75f705e301d3899071c67afa1869ec584dc2c3ed19ef3487ff06306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec0ed84de1614cd7ec19fb7f1a191f5a4ea748352d07cd12b72aea1969e0fb1"
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
