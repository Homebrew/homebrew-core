class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.38",
      revision: "7f24cdcfc559e2c67806d66abf6cbf97edf2af52"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "143ff1b63768f41eb8800ab0d8ee2c479d8b401e0f558596709e01e2d14b0460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30e8aa3f7096b3c7150a38cfd604b9ff4ea64e31b9694bb1877a5e311fa8b366"
    sha256 cellar: :any_skip_relocation, monterey:       "b68613ee326864d1c74b8483888f154828efca4bfd76f526a26b82c7d3374b2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2c7e20243a81d8f1e55829bcc4018bb56e4e935bd9c8f010bafd0cd9a9593b6"
    sha256 cellar: :any_skip_relocation, catalina:       "c1549cb04e498fef0d55e337825eb8ab9334b748869e9046e120bd8d82688794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72af7cf9488e8995cdc2f15c0d8a079dfaa7e6904c778350707359009d0592e4"
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
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
