class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.21.0.tar.gz"
  sha256 "53a4ab93fc06b5fc3ef02655d4798a1a65d12b9887b63e6898975fe4660a2714"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0442dfa2d85d2220cb0d79559878d71b0447850da77975307c11c2da7c0fb7c9" => :catalina
    sha256 "de13c20a85a6f638a4b6134a889fa52316916cac183d8fb5956710eea4e32453" => :mojave
    sha256 "977d34c18bac304b6e1a1ef3fe6d0d6a5be3204f3f6b6471204a78f5eedc1e14" => :high_sierra
    sha256 "e5f87605029c8558975decaa755cdf9566593adf08d0fe44669615e9869be25e" => :sierra
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
