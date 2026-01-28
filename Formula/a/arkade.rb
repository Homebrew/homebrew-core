class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.69.tar.gz"
  sha256 "790da4e453d462afd7fcdbf49f7952590f78298ebdfec39068ced0cfec2dfd08"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d68ceae9717a841ed019a88e2948df6613feebd3519d7b18b69eff231b676a89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d68ceae9717a841ed019a88e2948df6613feebd3519d7b18b69eff231b676a89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d68ceae9717a841ed019a88e2948df6613feebd3519d7b18b69eff231b676a89"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6d3319be71a1caec90066b06de088cb47023e93ba63a804002920460e3e4e2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b17a37d4085e5700eadcf047b66e89804eb3b0d29d22e3a2655632e4cb0c2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd6148c0084b24aa0b8d3cadff91663c300737ae892187e1c76210248733f50"
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
