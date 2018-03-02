class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.18.1.tar.gz"
  sha256 "804ab587dc9257db0379cc12043edec4ddced96f16967088e6d218afa7d46ff6"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc484826251b7865ad9c5c88def4bcfcbc9f6d76a7dcce31e85ebfc5d8d746e8" => :high_sierra
    sha256 "cbdcfa911da57ee09dd596731dce9f098ace21d73747a9936f7aa5b0fa356265" => :sierra
    sha256 "7b9b9bfe63cb49be63b3a5184a1277cbdd341e288e39dbfd3b23f59390d70131" => :el_capitan
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
