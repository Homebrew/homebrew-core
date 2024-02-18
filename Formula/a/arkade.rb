class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.1",
      revision: "39ffd8bb0cabc3387593296c8809aec55f55bf1d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "653ae0dea9327c3a614ca2a77e88b8f1cd5939e08fd7dfa91e0ed85534c38974"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9ecaab6e6348e663d4b81b1a2c1d813cac0459b43ca02e1ecf563c2bac25d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85de867a6ebe95e8818a6218071e0e50b1e9614abbbe02d09d3cac114da35857"
    sha256 cellar: :any_skip_relocation, sonoma:         "69eb8132874d08fcef5468d97485e6a66cc12898c858da7fb245fad971a55434"
    sha256 cellar: :any_skip_relocation, ventura:        "526c03370d06ccd0d85f6f9977d89fc4db54d828e3253da9234697d876b7b686"
    sha256 cellar: :any_skip_relocation, monterey:       "905f1959ba05473be740f7c6df6c781ba102e01775bb11d03980bdb7e7147964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f5b471a5f89c442d4a7b92e92b410fdcd6b7b745f08d8a452a8ea17cc0a693"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
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
