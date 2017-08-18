class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.13.0.tar.gz"
  sha256 "5863889e7a03d9e8ab17a94165c3d73ada091a004fd5dd98f37c89dfc346bb08"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa9c6bdf1a1c38a35b94d7b3d1d394de8540aaa18e3dd2443ad2c043ecad24e4" => :sierra
    sha256 "f2bfce8b25221e20a9f92596333432584fe02ab06e59c09c86e0556f11dabd7e" => :el_capitan
    sha256 "fbf56efab293e7c772aa6fae6c5485290d01be73777f33bc6f313befc6b39062" => :yosemite
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
