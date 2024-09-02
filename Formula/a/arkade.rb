class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.22.tar.gz"
  sha256 "4484d3408f78c9e72f5b018543492fac06e63692742b9ad01dbb93ab4acf36c9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70a237397206e758e9b9af39c146d15042af3e0e01444c9a7dbf5fa576d4261a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70a237397206e758e9b9af39c146d15042af3e0e01444c9a7dbf5fa576d4261a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70a237397206e758e9b9af39c146d15042af3e0e01444c9a7dbf5fa576d4261a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a39ca106130b09b9af2cc21e61e56702659f6cb2272be3662c719eb679937d4"
    sha256 cellar: :any_skip_relocation, ventura:        "7a39ca106130b09b9af2cc21e61e56702659f6cb2272be3662c719eb679937d4"
    sha256 cellar: :any_skip_relocation, monterey:       "7a39ca106130b09b9af2cc21e61e56702659f6cb2272be3662c719eb679937d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16caa17986c0340e5bc4195f9b7f927670800c669d7c241924681ca18fa291cd"
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
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
