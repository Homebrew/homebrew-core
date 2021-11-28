class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.29.1.tar.gz"
  sha256 "4729760a59d8390c615457d0a01ee38ff8f1055e9fa8645d5763d878c8239d74"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99cae4232fb1996710b8c9d2de984b02f8dbca7ac03774f3d49be1ce952cc265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ff6b1f128a8dd57ff8aa905adc26afef272447d6c7d06953e5723db1389adf6"
    sha256 cellar: :any_skip_relocation, monterey:       "4b0f82ff4b47d6f44a2e709df95ca207529431fb246730d58e286aae8cd7fbd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b364f6187f8cd12ba7e0d4b9c91abd54b351764a76ed90300595d712be17859"
    sha256 cellar: :any_skip_relocation, catalina:       "f0ee85989e412dd794c7b5e5be176dd6c06be239db96c2e1ecb8b01d5dd4431d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6e4780976395528e0e21c5ac457341621d5f167ed134e6222643823eb5614c7"
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
