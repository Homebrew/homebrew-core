class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.16.1.tar.gz"
  sha256 "62fdc873c9186c5e2ae1d2bbf14286758fb60b60a313aefe1bb45f65c160b3ca"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6bf7d3c9d637254f08851297f6c019468ce4701de33f7896c5697c7a0171bb5" => :high_sierra
    sha256 "9aa015149297cf697c1669a51f6438ab64f35a09e5ed0804cfb70d1433e92e3e" => :sierra
    sha256 "bad13b146dfea684715ae53b40e9ec5f23e47dd13ef4692e4276a207beddc6df" => :el_capitan
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
