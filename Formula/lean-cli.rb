class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.12.0.tar.gz"
  sha256 "16dbacc635f4b16fe1b4f594e1730459f0ef6cc095898e3499e04bef6ba8d8d2"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10f56d966aea0badd8fa7d4e4d5a48c7990f917874d7dca4ec6152883825487e" => :sierra
    sha256 "536d69dfc790f17e58515d61af0f46b2b46afe44dbcb37f8a8a7efe1db55db48" => :el_capitan
    sha256 "d68ecf2a214f7ab2dc3a1df04e0e6bff4392bf442fe2eb3919d5336f43b88377" => :yosemite
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
