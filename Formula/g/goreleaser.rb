class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.3.2",
      revision: "e8c2ef77358b4b1e59b904322824ccbfa3487ab2"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f88339ddb4d476fe0ffed2e09deb1299ede972821cd5ca486fd358b8f065eb12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88339ddb4d476fe0ffed2e09deb1299ede972821cd5ca486fd358b8f065eb12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f88339ddb4d476fe0ffed2e09deb1299ede972821cd5ca486fd358b8f065eb12"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b4b54a77a4d4e38e72a181e7c6fb7363d91a31001012a2dcab1d8575d53e8f9"
    sha256 cellar: :any_skip_relocation, ventura:       "0b4b54a77a4d4e38e72a181e7c6fb7363d91a31001012a2dcab1d8575d53e8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bef97f2177600f4e441a2b926de71074b8476ef419785065720d10419c1883"
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
