class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.12.2",
      revision: "97ba9a7a394b1f05495722270c824c154ae44328"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a7c9d2689800f53ae0081b026e765d46e3c7e79c748a82705c30d2698cf779c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0b0580ab9c48ca930d3dc1b2075759a6c688a18b5d6c0c3c47db36fc86cd0df"
    sha256 cellar: :any_skip_relocation, monterey:       "affd77b2002cf8ba5e7d7f823f23bd17c2a462f298f9cb3606132ade70177290"
    sha256 cellar: :any_skip_relocation, big_sur:        "248db688b7a2f0cabb98376725d0cb1052ce5b39fccb969cc83b4332b736ea76"
    sha256 cellar: :any_skip_relocation, catalina:       "f7184129072555b137960ea63baa907a1a20b9f5c193d634443630c5f776cce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a6409e73bc6932f55ea29866d4f3dfb258d238bba0926b8d1cdc63949b28d5"
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
