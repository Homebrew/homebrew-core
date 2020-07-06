class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.22.0.tar.gz"
  sha256 "c00aa7f6510aa9d19e4299acdadd8f726b37d5ce7c664514e6e44c287c5a2cf1"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a5f55ee2ee2f7ec1cc0da511cede9245b8410f0639da8eab0e7d5b47f7a9060" => :catalina
    sha256 "b5804747a881fe183502f58486d3e1a27336690c25f2a8aff6b08037409c7100" => :mojave
    sha256 "601dc511053b0af1c74b09354812f083293e0fb8c6eab7686949dabe17813cf6" => :high_sierra
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
