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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62f8e846467732aa82f0eecb5e675b404310e9445e13312be4ce268978bbc5ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbf3327a2952b163c19cdac8e024c7beb478d6d4610873edc45c6e92939469ec"
    sha256 cellar: :any_skip_relocation, monterey:       "d97a282bdf2ce1bdf09a443a87a8356434fae6f7316be3f5e2124f028b0b1ca8"
    sha256 cellar: :any_skip_relocation, big_sur:        "40fec8777e33015ce394234b1abbed6f8b2da746d5db5e8941762bc31d80f918"
    sha256 cellar: :any_skip_relocation, catalina:       "dbb5373f617a1b3d7cb9f6ed266244920209bd9c6bdd239e1a8981e294bd2cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb13d7a06f8c670a173b8084f95cecb95853543569cfd8359dae5a940fd5525c"
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
