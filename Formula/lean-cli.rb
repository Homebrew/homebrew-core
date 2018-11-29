class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.20.0.tar.gz"
  sha256 "6e3af7bd374ee2fd8e36f309a216c2b724e5a9cc437803623a645251ec885a27"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80924c75a754bcd7d11ccaae3183ce55cf9f11077e1de3795030829de49826db" => :mojave
    sha256 "62985d53a07b0a89fe58f650a1149126e78fa7f83c758282fc962725b83d7227" => :high_sierra
    sha256 "2f17346d09ebf56da72caaf31b329bca46cc508474eddff6d6b4cce34c298325" => :sierra
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
