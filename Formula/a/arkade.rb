class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.11",
      revision: "03f59803cd69f8d105088a09b6005057817cff01"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2093ce04b7b9be405bb7e660f8b7e2db82a988b265528b0b52d5bd82f802a220"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7753337c33b80e2782560a586b9892778979d580101b816d09bee1a5650cefc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e46285b17ea7c70359910967a38890b6608ceba7f0143474b6a07ad85ee5110"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ecd26182904a6e736627a91888af5f21824c970731fe1c71fb88f3d64d6de2f"
    sha256 cellar: :any_skip_relocation, ventura:        "c5053ccbc1dd340c8018b4d79d653dd377139f6a9c102405ca1cf8f9e2c92432"
    sha256 cellar: :any_skip_relocation, monterey:       "232cc2cbc269b2be28156851a29a7603ec7829ee886e3e7d16c853d7e3b116aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47b56df9aa52f61af4dc66ece92de7bf0c74ed974a5152a8ac7c0bcf57c8acf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
