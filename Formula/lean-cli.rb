class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.21.0.tar.gz"
  sha256 "53a4ab93fc06b5fc3ef02655d4798a1a65d12b9887b63e6898975fe4660a2714"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b086f0d4578758ff8e08cd8f9b862dddb5c89baf00e195dbc726c6f2370b9a1" => :mojave
    sha256 "aac167b048b0d4e40f35f4a8fd6a088b6a419bd8f0a3aa9bc6d00535d9bd4e6b" => :high_sierra
    sha256 "76de0098ca757563038eb91dd489d6359b0a901aca6a4864f0e3555d07f379a3" => :sierra
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
