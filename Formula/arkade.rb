class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.35",
      revision: "783821adce48447b4d9f424fdeb9d7c1b76b0e43"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26b37a0d3a2a5250cbf9daa174955c827ba005306a8825cab738476033f1d584"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc72a878839d2ae6653988c973b108a61fa25a7673e77d55750af8f1fd668ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "0a731c6e51becb314fa6e336e21178b5bcb2fa39b062466c25e2e45e90774ab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "424a06ce5fd7a87a43fa15cdaf1a7abe35e47b3ce4450a17a599c295964ecfd7"
    sha256 cellar: :any_skip_relocation, catalina:       "4b376403f5c5ef58b5405bba7245c2933de9bbe0dc994356050b0e7337731a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1311afb63f17ca2b98d2fe198f40f2443568d575b78b198ccbb172d7f414c25"
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
