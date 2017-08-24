class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.13.2.tar.gz"
  sha256 "de150ad6cb850328fc95f218dd558ca75d858097029001c5223ea6d02bedefba"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09e5624f8be9d17f71e51b8c7478ec46de4fae0acdad8772f2e35ae863d7446a" => :sierra
    sha256 "8a6d2b297bb5a846cbcc857bf66ea5eef515c5fe342684dab5304b3ea73268fc" => :el_capitan
    sha256 "cca9457b70a80c7ab8f66b0d2d0fd5a8251bf6bbd7a40127e65821e89ade3c2c" => :yosemite
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
