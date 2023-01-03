class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.14.1",
      revision: "7be70934534b5c9798b6ab1b7b3e5c35df7e8b2e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd7c04fcee850ce5ccac69eff4944470e039fbdf5699e9fb75fe7e0b008e3a18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc44434366e4c455ef3a7777c924b41c2d457b9f12b2c1cc3ca95d398672eb40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "608d6ba1120b076e1b4e88a28067b86ed5a41774762d5f0e26e3b2f7e0ea1578"
    sha256 cellar: :any_skip_relocation, ventura:        "d683b1a62f4c390c85132b35ff68a85d7b18dc5ac879fed36bc651f15a80967a"
    sha256 cellar: :any_skip_relocation, monterey:       "f86329ee8117fb599757cd86975178ed9c561458443faa8cb7bd9b7e4db4dc6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb88a569bebfb36f4aa7547331396a3c60c953749d6f0f229bb28009942e3f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f74432bd9ff720e4f9888ac7c752c4889650e3ed9d8359f3ebe3b2025403bc6"
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
