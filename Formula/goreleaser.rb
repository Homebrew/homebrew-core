class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.17.2",
      revision: "6afe717dc9e716bb7e2d893d500fdf3d8b94b872"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e1f1e3503c6346db69eed926bd85b069f1bc94c1e1009ea3333e0d0946a5127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1f1e3503c6346db69eed926bd85b069f1bc94c1e1009ea3333e0d0946a5127"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e1f1e3503c6346db69eed926bd85b069f1bc94c1e1009ea3333e0d0946a5127"
    sha256 cellar: :any_skip_relocation, ventura:        "aff3108d6f9d17074538ef50bec2e412418afb39c849e586ae212455caa0a547"
    sha256 cellar: :any_skip_relocation, monterey:       "aff3108d6f9d17074538ef50bec2e412418afb39c849e586ae212455caa0a547"
    sha256 cellar: :any_skip_relocation, big_sur:        "aff3108d6f9d17074538ef50bec2e412418afb39c849e586ae212455caa0a547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3331bd2fc596ed2411331b1b2b472de342ee4358fc26e73c06c26c0c4fd140f6"
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
