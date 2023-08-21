class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.27",
      revision: "69c0dc091a32f2e04d33903d706a7be82fa2fb55"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac514334b1b6789bbdcb4ad11e5e787393270755abeb8edee113df8153d64b5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d83215e6961efb269fda65924702c4c63aaeb03c10690c2c13efe36e4cefbad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b626c7424c2903ac56898b061f145d659244d72134124e4beea5f56533b62517"
    sha256 cellar: :any_skip_relocation, ventura:        "5c55c864c68b33dfafe55272b63087a0a1dd51606d4dfc4b524ad8875c044a68"
    sha256 cellar: :any_skip_relocation, monterey:       "d21cdb11968d984e4d7fc71463f76990145a609aae4517d2e7947fd3af451c74"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccd5cb17f37f273d9b40840ccd5cdeb04ecba3fc5c95cc4c024c1e167426231b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f08bd66c97b517e927ce43ed5ee19dd942af77b45e4a17858e70b2810d05066c"
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
