class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.23.0.tar.gz"
  sha256 "f87fde319a9275db81eafb205d71760bc9548551ba9f781a63ae74224219bebb"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c555c1ade11f253528179f5f89971400429c5705b1a174cdad9d86ef40444d96" => :catalina
    sha256 "8aed8883f1cd579577e3e3aafe62768a37aff569e2a1c4561966fa5c7b09870b" => :mojave
    sha256 "99bb082889d69784efb02015bd81b986d6c849e7e1a4826cc7dd6f68d1941811" => :high_sierra
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please login first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
