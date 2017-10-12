class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.16.2.tar.gz"
  sha256 "70c31c81966bc12cf9de22a3192e55f03c64055a907e42995e5df98db2c89a32"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82a506c628cc24f92033901b2e749b2a13974839e302a2bf956c1917586ee803" => :high_sierra
    sha256 "0cc1b67574f7ba36520fce5b900e12f0fe4284dcd3c5ff8793efd633553f0d08" => :sierra
    sha256 "f0cbb6fb96acdf908a3bebdee183150e7170da5f90c163120412152d7375a95c" => :el_capitan
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
