class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.15.1",
      revision: "7c6bd86b286ee76cfb0a0b4ec17d18d4ee9daeec"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f03f05cb05ab4659dbbb31fb67deed08dadbdc4dd11b3bf0a000d3ffd3fec4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93165b5948db4476967b82556bcdadb434c3f47a9eb1c2290a81bcb2e0be1615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b5b61ee6434d04c7dd33216eba996e0aa90cb35ef50aa78f58bc284224c4b89"
    sha256 cellar: :any_skip_relocation, ventura:        "a64abdf022f834e81cf1bd1d56669e2446125d981b3eb067b637e19cfb2696a7"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd522370d1ba1ba719d0400dfd16d08f90e65d534e082f124b7133c76cc264a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0b525f14359946c2ad10eeecd7eeeb04a8323bccd6297dc7fa7e8b18ca78803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2a621efab95194391bd1f6ac39f81a52eb61130ce605210cac283e190fdf795"
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
