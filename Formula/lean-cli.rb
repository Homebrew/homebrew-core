class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.13.0.tar.gz"
  sha256 "5863889e7a03d9e8ab17a94165c3d73ada091a004fd5dd98f37c89dfc346bb08"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db0870da4066f2f3349955407e1f8b260d9827126d0970543add4c729212b573" => :sierra
    sha256 "5bc33ea91b675078653631801797da806792fc1fb2b66312bef2b56b1ef71685" => :el_capitan
    sha256 "8904791a2e32928ee05696d66cb0eb885c44a465e6001a0439d648b8b0824424" => :yosemite
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
