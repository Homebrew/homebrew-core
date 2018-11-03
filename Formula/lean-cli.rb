class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.19.1.tar.gz"
  sha256 "050e1f06a2537a7be4987a9fee103dea60bf1dfef06f3ef96bbea754609d4843"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c2f7b21a57bca316759b8fb27f385aaf22a4b4629589c3bbfe1c11e3b55b2e2" => :mojave
    sha256 "e02764c17c92fda5191a9fd44e74e90601f116a4b9073bc14b4e0cee9769b243" => :high_sierra
    sha256 "c21d0b443b813797b366c8b9927f70ce31985771291500d0ab85535597faefad" => :sierra
    sha256 "bf30f7788c9eaf8b0afa00f85ff73d5111fcdfa28e3ffc4a130fe591fcf17b36" => :el_capitan
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/leancloud/"
    ln_s buildpath, buildpath/"src/github.com/leancloud/lean-cli"
    system "go", "build", "-o", bin/"lean",
                 "-ldflags", "-X main.pkgType=#{build_from}",
                 "github.com/leancloud/lean-cli/lean"
    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
  end
end
