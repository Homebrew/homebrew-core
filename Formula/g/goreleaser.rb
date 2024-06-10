class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.0.0",
      revision: "f35dcda343ddebf9dae706c8a86aa5915501fa84"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9968a0ed20b8908c9492434e343374dcc27cc6296259b2fd7a14da6387bd0d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac0884a9494666ca2077785bc29a2413e65c865069354b8001fa9233b1ec8714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa54ed7d9c11af0ebceb14ed5d078401bf7de49583d4eb948585a8106b4faa0"
    sha256 cellar: :any_skip_relocation, sonoma:         "958ff6b1bb59900125af679dbc877143975d307cc22147c98120625a17ab9ecc"
    sha256 cellar: :any_skip_relocation, ventura:        "501a77463ac9e67cf40f2a79b3a4fda2de31805911b6a8d29367ce999c521608"
    sha256 cellar: :any_skip_relocation, monterey:       "74cf8bb882824537c6abba879b2cbac9e723b4f15eed437d2c035636f101d8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f91d53810c64d15fac5c843a4b53ca79305b5c2dcebf8e1bf5812e1be5e1cf6"
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
