class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.50.tar.gz"
  sha256 "7c26e840d686f974d1d1c54480ab682c6623062a82374f5e2e9395b39e2643ef"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3098e71f367e3a8da74d930595c1108bc1f1ea5b99ca058ec6fc9179ebdb61b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3098e71f367e3a8da74d930595c1108bc1f1ea5b99ca058ec6fc9179ebdb61b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3098e71f367e3a8da74d930595c1108bc1f1ea5b99ca058ec6fc9179ebdb61b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "93491ff6d691ee80f0893d5b0bf23bb5853b9d52dac077e5efae8fe54dcaea0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06f6fd730d31fafcea771937cc7ee8b7539c0c880e4363d84756e787d18e9f0"
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

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
