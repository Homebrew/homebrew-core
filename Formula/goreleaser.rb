class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.13.0",
      revision: "b76b65875d2e60d63ff571000f4c6c890c8dd70c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf598986ca20f9556570d5268a407162ff21a66361af9180d078b310fcac9e51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49f05ca1465e77cb73947cdfc569d5ead41209ba1e3d1e0f650eb1ec78657730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b98d79cceb12a1faf4597077e4c0f36c9c43a5fe3046200ee104e88119f4b00"
    sha256 cellar: :any_skip_relocation, ventura:        "1f37dbdae547d043caf840255aa28327dcac8b12cd2af8e5b8950f57de1849b8"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e65ffeb5968f728554db40d29550e5d57d983dfd434d79c7cf0928fcf832cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c6e86b334bd4a0fc98cdf7eb93ac14dfe4d2ec02edb2663b2c34d6ae18dcba3"
    sha256 cellar: :any_skip_relocation, catalina:       "6dd9bcfd626f0cbf7639eaca248e9b35a49a4f58ac8693a01d239bb15e2ba2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab0519edb8c0fe80451daf7d2d62f6bd452d1c57442b253b97fe7cc5e577bb1e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
