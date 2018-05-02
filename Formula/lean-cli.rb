class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.18.3.tar.gz"
  sha256 "ef8212965d303bd053cb56ff0f4a751e3c184a690e4187a569ba7f990bbe5986"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77b5f2c608a71b350bd0648f2a1e088176561aa6a4d5331112307ef64b9cedbd" => :high_sierra
    sha256 "373bd2885a6e6ccea9c4fb8c453e136670602261a494527cf0efa85c365712aa" => :sierra
    sha256 "0e58d88cf168e86ce8e2fba7774518d7f64d80ae63d812ba68438c715d1d1a6c" => :el_capitan
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
