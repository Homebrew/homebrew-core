class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.12",
      revision: "fda8a74d6a8ee80f135cdd6474ed2fdcb1ed3bcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46c9669f13a30d7ac0dc1c634e70884c396b34fb9ebdeae18578d250957d5e8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "578bcb88db0bf121146a3e642eb9996559ad59dd61136e077d43f6bf0cb1ca56"
    sha256 cellar: :any_skip_relocation, monterey:       "0030215064e7fab3faa5692b938977daa1e0aa21dc8acadff16dfc102d47ae54"
    sha256 cellar: :any_skip_relocation, big_sur:        "35490f18b2574191a00088c4c771ece3335690c9b87a707c2996db926ecf5dbd"
    sha256 cellar: :any_skip_relocation, catalina:       "b93b287c2bbfe3601842b3cc7c460373211b61706f12776e6b9785687b969b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e034422b6c7cfee895bd018791877c770429c0ec31fe92543cd928344253e438"
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
