class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.60.tar.gz"
  sha256 "cc4f7279a39c46cbd1af5f62bf5fbca40d5365a19fc511cafec26053b6a39ebd"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e71b15c0de89fcbe33020cff9784460648a52ad960b74008c507e21b43d3d387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e71b15c0de89fcbe33020cff9784460648a52ad960b74008c507e21b43d3d387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e71b15c0de89fcbe33020cff9784460648a52ad960b74008c507e21b43d3d387"
    sha256 cellar: :any_skip_relocation, sonoma:        "f98f59a537fb50e41fd8de207f54179e0d8a58b46f5c70e6f518e50d945f4a36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b5b9363d94abced2ce0e2a7e0fc91f148a7b0bdbc10a5b19a43f7460f2144e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07d2375a9c9743354d82182c40e6c2fcfb066b58530cd252dc0709f68826b6d1"
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
