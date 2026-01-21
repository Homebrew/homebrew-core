class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.64.tar.gz"
  sha256 "9785a1200de1b01943a1bf62c4e6b16575ff974f5bb6c2c6c38b9ba7e0178c64"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "724b1668477dea8d7007dd537b28b0814caa8fa205b626cf91d9f0d61b742be7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "724b1668477dea8d7007dd537b28b0814caa8fa205b626cf91d9f0d61b742be7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724b1668477dea8d7007dd537b28b0814caa8fa205b626cf91d9f0d61b742be7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76a1c4ec7d756e934ebb966b0d10a8ade63c9aafd2e81bf9a18bf4a1d90bb9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2951fae1924180cecb2f5762ebef7bfc0a9ae44a932c95e9198c574832313fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3043d5008b712951060001a9b0cfe9bb3bf12d2f670fdb03fe42f6b7a34e5c61"
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
