class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.11.0.tar.gz"
  sha256 "8816af3f566b14bfed90b7cd1e172fcdd8d4690dfe4fef2b62af1dcc79c06c41"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0eb9ca63e7bbb1689aa8e57c1ca8ab8e3c6e2da5dba825d3b43e073296c86f89" => :sierra
    sha256 "cd8c075906966348db428f8569caaf856b10f60888f6560a9bdf8af81e8af768" => :el_capitan
    sha256 "7e3b0a06c37bf513def7d33662608845129aa68caf8f9e45f6c080ab72db875c" => :yosemite
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
