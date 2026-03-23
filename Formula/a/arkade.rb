class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.88.tar.gz"
  sha256 "26acef37c21cead9d341477fb9b29fc1d685c7fb7c6775f49c2ece905da1f119"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4474e54197ef2b882f27feae8ea0eb34a73a57244c2eae9ef4ce5cab9d30fc83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4474e54197ef2b882f27feae8ea0eb34a73a57244c2eae9ef4ce5cab9d30fc83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4474e54197ef2b882f27feae8ea0eb34a73a57244c2eae9ef4ce5cab9d30fc83"
    sha256 cellar: :any_skip_relocation, sonoma:        "a133f137c5fe763e58fffa779fe17d411599e9c064dfb73d455f1f0e36b579bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1c2571af1552cd9e28054ea49e99f7e496db0df48d9e25d06eeebd1c26cc59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95f12343cd02e45175867f54d0fc3bf621c41f00d15f7fbbd2c2d608ccec99d"
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
