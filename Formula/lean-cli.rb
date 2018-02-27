class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.18.0.tar.gz"
  sha256 "96584706cac3eb2ff04d16d8b3dbbb61c236ac22ef6c6366970583c5a1b7c963"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69f56f34e007558aadf3e26d41fa10218b7d53f4eef6b513eb0d1052cb0793f5" => :high_sierra
    sha256 "c0a3d9864ce3c81646e8ee5df4f6b66aef507eeb60efa5165798fa4e75b185a5" => :sierra
    sha256 "9f7963c4157e1068113d4402a6dd6cfde11d54414804ade84f6696ce6cd226c9" => :el_capitan
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
