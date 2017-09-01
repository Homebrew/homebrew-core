class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.14.1.tar.gz"
  sha256 "9c873317a5924567bb6160aa83b49e499b0b07b415419e2f82f0c42de61d7c98"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e6d01d12def73c7f5b9bfa400d193d3f5d31e4526dc4841725d0336293a38d5" => :sierra
    sha256 "5f4d76977586126365945f0dd96feb27e482f24af5f7c11ea9bebad37ee5584a" => :el_capitan
    sha256 "4b77d14d131695c65609fa114bb0dd7458c3edb036d313d98825da2941f248f8" => :yosemite
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
