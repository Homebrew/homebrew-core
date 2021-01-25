class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.24.2.tar.gz"
  sha256 "c60a153482af5485089dd500d58f947f5e03688c4c572243e64b18eb0a064f52"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "766c9c6bf48498015b6ba2a1a60d2e4743a668e33c3e12268d1bbd3142c6c425" => :big_sur
    sha256 "04088e4e5a87da1e0266edac6c2ecb7b155e7cb8a776d9794729261d459d20a4" => :arm64_big_sur
    sha256 "b717de9611edc3ec6fbde30c9391dabf469e4c2342cb30939b0ecc7ecbf7172d" => :catalina
    sha256 "c46be6237896b2733a2f630087bd23bf70fa589a1aad5b67ceb66ccd57e2cd19" => :mojave
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-s -w -X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please login first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
