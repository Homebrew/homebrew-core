class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.244.tar.gz"
  sha256 "d2ccd3bb0b7ebc3cd6010033df27081d612a1ccdc8480532b3c5f988b0bfa17f"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa630330b9adc053ed6ecd8d250d1d3826d29c6f01dc2c827268cf4dd10d3049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f73ffe38d7f15de199baf961331471c86f692dd68bae866da361d7b6e9a2ea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae4fde66219090e60dd0f73de5c73a09d4b5265cb31fc0110216a9c5d3083ec3"
    sha256 cellar: :any_skip_relocation, ventura:        "c960bb94a22292606fdae8f06676f81b6a6ef5607ab74e14291d3fee9d1ef009"
    sha256 cellar: :any_skip_relocation, monterey:       "9046ebcfd9d2f86ba1c6d8c541ec8ea130d6a95af96a95c1dedf7fcc9372f096"
    sha256 cellar: :any_skip_relocation, big_sur:        "b50d16ce1203bd3ac4e12855ae5ec25291f464d22d3acf7373a5082eabe023a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43be0d87e4d67c09dc9f9d6e2a445d4cfd3c69d8e9e0750ca9de92f58cebeb5d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
