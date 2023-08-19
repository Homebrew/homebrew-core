class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.258.tar.gz"
  sha256 "31cae2eedca230f6f073c61c26bb26f52010bf774418386c65bf036302d0c53a"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a45aa2ae0cdc4cb84063f66c4dbba39ec8bf70d44cd5be7d5b5ba76648dfa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e324bab92d5df23180ae483f4048206f9994762699be0656d6de626fc762b1cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd0ee9911002108f123520a6b6350d19d3862bce0f2bee7f35420edfda71bec1"
    sha256 cellar: :any_skip_relocation, ventura:        "f374d86341a4c7c063004e51e17518a95f7d0b06307d110ecbd474084cd2f0d3"
    sha256 cellar: :any_skip_relocation, monterey:       "3bbc38cf5408dbb17789bcf0903fb485712c645f37c5fc56188b63f4fe68a835"
    sha256 cellar: :any_skip_relocation, big_sur:        "8395d5953b2b33500a009cdf9e2e386d9f80a9d7cec918ef918a2dddce1db24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec9482c6f2065d11de387c170884be921f3a8c9e5c85ffd90b199ea273924ce"
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
