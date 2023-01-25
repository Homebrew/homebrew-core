class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.57",
      revision: "2be0cbe3943c127e398d4c3fd5729b7be93203f0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfffe63db9963046f085885ad06ad31a19fc48d7f3f2e6722dbbd84ed4736834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff34002c6f587e414a1988dc2be74e35bae90fb41a32c9b094a24e8e89e16bf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c9ebb6cb9ee45cb1a662c087fe3160ca4408affbecc2f18796bc53c1ceea959"
    sha256 cellar: :any_skip_relocation, ventura:        "803053f9afd5015092749e244efac836cd1c201e69252eec02c933820112e0be"
    sha256 cellar: :any_skip_relocation, monterey:       "e8aa3a05d3a33054be7d6d7796a1d5119534f72740f6a33aef76e85767845b35"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ad71400c6f32f5fc3926b01abf565d412a3ed483589275b61c2d5a011864db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7188722ae48b99b69fa61a311c17c9bf0817bd77000c4bac0bdd16ab889e318f"
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

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
