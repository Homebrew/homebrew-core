class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.16.2.tar.gz"
  sha256 "70c31c81966bc12cf9de22a3192e55f03c64055a907e42995e5df98db2c89a32"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e80626dbf7efd1e5c509e5af4c7cd92c8003487c5a3ca1ed989471aad785c80" => :high_sierra
    sha256 "e9c7fd636b43d700d52e45d07d7ecf6d625e0b3df61b18c5af979ca202593519" => :sierra
    sha256 "3a33f49c57410134a2d8ae4f995b3bf67228cf375bcf5460f2bc096d34903430" => :el_capitan
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
