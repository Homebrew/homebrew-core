class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.1.0.tar.gz"
  sha256 "2453bd3c89d56c53dc995a2f6eae2161faec41955614601d2e028f95635b6313"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3f7c6fa12a9de98424bce49c809897cfa3c585cd9da0a873e960d7065728124"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a59d6806979cfeb03dfb144a7dc1faffbc6ff240022f8da9861bdca66ae2650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc016fd06623d63e3a7ba4a517300526b9f43b1dd660b4b125d9b4ec5b7b95bd"
    sha256 cellar: :any_skip_relocation, ventura:        "91152db2c2b4601cce89f336f7eddc1f872c0aad8678fe080fd7f0d7bbc00e1e"
    sha256 cellar: :any_skip_relocation, monterey:       "44f0b9fb4047a2c4b4e8f8fd2ed1caa2217dba378697563fe18c83a4c7bdc3d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "700f97f1dafe246ded16a9c51331c50f85086d0c894e28d4cd68d7c58674a9c5"
    sha256 cellar: :any_skip_relocation, catalina:       "a671ed40ef27195e163e264b02affad345ff67b048982c06c65bb904360711a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f89fb965cf2378ddf47cbc3d83f12d09110c33565f760c8775ee9005b571d4ec"
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
    output = shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
    assert_match "[ERROR] User doesn't sign in.", output
  end
end
