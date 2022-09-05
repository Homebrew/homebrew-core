class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.42",
      revision: "cd54f6a171afb07ef27f8e8e23e9cb13a4e3878b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9073ab9d168066270f0f4a8e39166e591b13fa99882a676d2da8a1decc0d954b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e64c5a73ec01668cccfe0bf20654b0ce6a7b1d12f93e093c5d8641f87587a51"
    sha256 cellar: :any_skip_relocation, monterey:       "fa38ffd3a4dc80bde5bf0df4243165b3450e11267014310ba19bb8bdf502d1be"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffa78aa2f474a8063201a65fb04fd209b01d35a1d94e45346bc2f0dbb2e17e2c"
    sha256 cellar: :any_skip_relocation, catalina:       "1e8010772ed33b779752252c3bba8a192cf139fb4446833d0857a5e7479b25af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908bb3f5a836b468d6202e61d8559a6dc248fc948efa84d672522ad5224cfbec"
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
