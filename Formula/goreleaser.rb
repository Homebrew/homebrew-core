class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.16.2",
      revision: "9f91bea9211465901bc5407bbec5e7bbbeabdf0e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6c965e7e5f53fd05e425d08277e9914277a20c7b64ff6b710c42322b26ad92e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6c965e7e5f53fd05e425d08277e9914277a20c7b64ff6b710c42322b26ad92e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6c965e7e5f53fd05e425d08277e9914277a20c7b64ff6b710c42322b26ad92e"
    sha256 cellar: :any_skip_relocation, ventura:        "ad9c9280ea3f38d2fb969a670f76d8efa24b39b7a1278b86433204053c5c4277"
    sha256 cellar: :any_skip_relocation, monterey:       "ad9c9280ea3f38d2fb969a670f76d8efa24b39b7a1278b86433204053c5c4277"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad9c9280ea3f38d2fb969a670f76d8efa24b39b7a1278b86433204053c5c4277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f67b25c0f16dece8ea4726aee8b00b79e83fd011ae50180f186a742b4ad76f"
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
