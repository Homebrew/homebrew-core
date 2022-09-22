class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.45",
      revision: "7b7ade38cff998b68886fe7f1260d080e881383a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83fe5581a1ef93b5d82f6d8e5a29a5d0475ab9a98257d38f26bad7d7dca0e952"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3048788410876f6029e9ea33059a155bf2a83ab8ef11ace48fd70311f77cd03e"
    sha256 cellar: :any_skip_relocation, monterey:       "b3438463a4d54453a97784c9c5f2e701adc4d638fe696e211d31d8b5d7b839cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "93a98a9200c20c143a84def76036d4065ef865c90c27fa5fea308ce6a43e0f19"
    sha256 cellar: :any_skip_relocation, catalina:       "c4f93d6a433ba896f287a3690a47d0f541f903c7bce119fa125bd98773efa6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea7de68711f43e077691d11d0681fcc9b966655b64a0805d0c033bd2e8d04e2c"
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
