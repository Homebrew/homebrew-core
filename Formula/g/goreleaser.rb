class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.25.1",
      revision: "6a7a9ba3995728a4bdf7b5fff770d8caeb3d2cc8"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4716dee859a1cd132da50e64ef9714c22ead9b166d6aa097ae966a91ba6dfb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13a7a39a9e81d3f6f8818e4d2cc0b3b79926e589adddfb805aed4f859d969f31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3322c018831eacd3451e82b76c5f3b88257bc7778eeed796a7903841811b62cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "cac834ce95931726b7157548b03a340538128ec302fae2122eaf6b7ad16dab2e"
    sha256 cellar: :any_skip_relocation, ventura:        "082f33a10889c992b7d2fa7a5c4b6aa291ba30fc0f200e59af4ebc5941e2d531"
    sha256 cellar: :any_skip_relocation, monterey:       "fc1ff7b115a8259f301f1930eaaf4b34bcd1ae3fa0acd09fdde5ae4b4958b60e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "573136e0b14e1a5985133691e174ecc10ead776063a887e3646c03b8e835e2e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
