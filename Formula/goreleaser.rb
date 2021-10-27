class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.183.0",
      revision: "be6199f08167cc85b0b16cefc02d8106237853b1"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9502ee5583539d5da33e049c2faa4425a03c4a981ff5bdc7e87b993b224f6b5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7ec91f452b653e71c8b426b61b1e0fe76286cf0826d8769b07e67a5bd4d6e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "8a1990ab2db388ec075c8974d661f7a99dec9e1f32e1d2be16e4037392a67056"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce8fe20b1dc17457823e9431676eb5dd6ca9a1047f7f4574c1ad337360fafa81"
    sha256 cellar: :any_skip_relocation, catalina:       "45514896b53f86a0dbfa8f6e6f0fdcce4b154d9e148260dc0aaad59186d2d7da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd760668a2c78df360eeaf3fd9717c2d2f93f83dc7f3c4b530147f67e02136d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
