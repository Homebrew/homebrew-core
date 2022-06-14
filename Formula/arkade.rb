class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.27",
      revision: "aab83cd4dce85fbe2bbd3990deea0d6e6097c4d2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3854ff36859401b2ccfc11cf8df15794244bfe287a15adf37abd682fd7419734"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab01985b65a9679f73f986cac6966b187fbcb511e37dbe235c16e76f0cf7b3b"
    sha256 cellar: :any_skip_relocation, monterey:       "98756324260cd551e779ef917d0c64ebed1d0c17d9ff649588fd93839de3c95f"
    sha256 cellar: :any_skip_relocation, big_sur:        "72cec566d70d8b910405a060e760e4435b977cb6cdf03706cca58f60dd841fb5"
    sha256 cellar: :any_skip_relocation, catalina:       "be9e13e0bb3e7c5348aac912ec1f659f04ffbf47f39735bdeaf650140a48968c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d64b4745ac6be73c4ec77bac66adeb74d41fe278ce976d1b61fa50e772a4f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    (zsh_completion/"_arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "zsh")
    (bash_completion/"arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "bash")
    (fish_completion/"arkade.fish").write Utils.safe_popen_read(bin/"arkade", "completion", "fish")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef _arkade arkade", "#compdef _arkade arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
