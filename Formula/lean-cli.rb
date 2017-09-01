class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.14.1.tar.gz"
  sha256 "9c873317a5924567bb6160aa83b49e499b0b07b415419e2f82f0c42de61d7c98"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cddccc2f111f56640af49ff0c1a9323c1127cbf966d848ffb14a458dfbeb252" => :sierra
    sha256 "2f58c20bd3dd954d20e0004b643da1ec4022fe2739a6f958e16af05e4171b87e" => :el_capitan
    sha256 "fdbb599aeb46b1ec584192ddb420d4806efb514958c6acd4fd38042c5a65daa2" => :yosemite
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
