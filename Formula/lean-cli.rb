class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.27.0.tar.gz"
  sha256 "8d9219abf27ec909577f9736456478242d99d5e2ac0d621fab7c7bc85cce9dd1"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf9796552a4dfca0776cf18f2ae98c87cfefefcd1da07bb67d84befd9015ef05"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdf13498063f99b7143d9ffd1722fcee5f651ca0fba14c50947f03990db0ab5b"
    sha256 cellar: :any_skip_relocation, catalina:      "9c3b2751d74342c94f50f8cefe330cd0799475011b6b586af9a1cac2ee312c8e"
    sha256 cellar: :any_skip_relocation, mojave:        "67891ea82e51278c2f3016ee9a0c7d92a53dd0e3b3e45597621b946911c001bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9a788b057f52d290efc62ee27ae19578e06fcf0b1c9137dff8da0606d9dd03"
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
