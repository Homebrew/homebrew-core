class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.47",
      revision: "cff5cd05cf86fba34969a80942c4d7b015ecb5e6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9937b4c09d57dac8fb43b9501076105b489ccabb6c4ebd932afae85a538d282"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3a6d0efa11e7813059cc33a2996fc0925d124e78551d76d22a9fa0c04f46e20"
    sha256 cellar: :any_skip_relocation, monterey:       "44f0531ed220b74d2fec309ae9141c5f8ce01120e1b5598ec93bfd9d4834149a"
    sha256 cellar: :any_skip_relocation, big_sur:        "873a32470bf1aa9c60223e45ef4e8e4108cd4d0cb93b484bfcece60cd221518b"
    sha256 cellar: :any_skip_relocation, catalina:       "a2710243eb91a1137c4ed4da181495be9ffe01d4181fa92e05d12bf0765df2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ddf56b270d04bfae1201792abc28787153eb7c86a880cdd54f3f82564e0d3ad"
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
