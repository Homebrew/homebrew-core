class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.102.tar.gz"
  sha256 "c777c95ce10622e328b46b097885ad932898ff6e9e49962176530b3457151eaa"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0f7036d2c8a632e8b7da8f12a870516c4dddfa63410fcc2fbc109ae1c951940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f7036d2c8a632e8b7da8f12a870516c4dddfa63410fcc2fbc109ae1c951940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0f7036d2c8a632e8b7da8f12a870516c4dddfa63410fcc2fbc109ae1c951940"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f5d31d96a8c9365c9b98f72555b6c05dee874c9ed7aa311c373839fed802e1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f06e6222234e2f8871c7be1791c5fc818ad38a61dde31c98ec51d3244b201f1"
    sha256 cellar: :any,                 x86_64_linux:  "66f87ee49a39d726cda5edbc484dabe74af18a8c6a7427156738bf2e4aec9d07"
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
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
