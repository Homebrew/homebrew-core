class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.9.0.tar.gz"
  sha256 "bc903544480330c67a546e054c1c84218264236337c1f32001ec5ea527638737"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "802edb29ec8b42def90ebbf568d388f1160c68214afefb1edabec94ca4f41813" => :sierra
    sha256 "125bae40b85b740d1c5a4c824c2461df18e6b41c6675c4c4079b7aec84f22d65" => :el_capitan
    sha256 "0ef19b19f1ba3bd235393a643fb17f0c3bd5dd87710c509e5fb17d8c7c5ecacf" => :yosemite
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
