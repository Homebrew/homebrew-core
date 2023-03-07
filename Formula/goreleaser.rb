class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.16.0",
      revision: "945b5453d953e36c7fcad8ff64206c021413271b"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3e4e816603e99a4100a82e6e5ec619f41fbae4a4e1ac228fd7271af9d0324ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b495c1ba3f4e27d2f1d2f07ddb282700e1aa8b5ab44ddd80c1c15b6da771c635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ef6292cff3bd5b167a84d83fc47ea45843c6597ae3b24669053cc8f095876ca"
    sha256 cellar: :any_skip_relocation, ventura:        "1868de67500c1a0fad8f7ddcfb060e5c50b4ba5a26af3573015d75c25c554763"
    sha256 cellar: :any_skip_relocation, monterey:       "e013b52e058d33437dd9bc7e3805c7e646376874804607e9c5f1f29101a6ecdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b96844a80a708eaf0618733ab7b72f3df90499d7a4973d2581370722494e355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c31882e771e8ed065011d17cc12128c5d17b44410b0dc58d4c16c989309f74"
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
