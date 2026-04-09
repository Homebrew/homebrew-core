class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.92.tar.gz"
  sha256 "e362429c74a8ce70661a8d00c1462cefbd577cf009c772ac4c10a6ad52fd2d83"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed0865133b87a018a0f40d3eecbdf41d12944f8eacefa73868ea893594ded04b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0865133b87a018a0f40d3eecbdf41d12944f8eacefa73868ea893594ded04b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed0865133b87a018a0f40d3eecbdf41d12944f8eacefa73868ea893594ded04b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4400839e5415f09331ea0451a8899e1797dee7a6204ac35c1fe51554af7f2557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01088f704b433af2b0388a41e38090aeedf9b8aeccd09573e1f060f91ef9c3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36867e04c516f8e3de77897d66b81a945c1d682e30f2823f420c3dc436fa4454"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
