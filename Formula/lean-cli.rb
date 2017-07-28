class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.12.0.tar.gz"
  sha256 "16dbacc635f4b16fe1b4f594e1730459f0ef6cc095898e3499e04bef6ba8d8d2"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5387c1b328b5f9521514f4031618f6873caa3537e5978404f9aba784a1df0ea8" => :sierra
    sha256 "8f16270830429a252868525275f6ab548e003c40a13f02c7975891f273e2e202" => :el_capitan
    sha256 "39a16ecacf5fcef599d9c254d9282442094892765b8d91e7f5831ab26bd04fca" => :yosemite
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
