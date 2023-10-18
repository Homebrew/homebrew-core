class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.21.2",
      revision: "26fed97a0defe4e73e3094cb903225d5445e5f0d"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73c2fc29851636b3994fc35483cef1ce5b4c9599cb5b79ccd88311ed07a4a3b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af4c99b63121c79cde605a125f378aea61cbe3f257d3b855b09f14512b407b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e501312140d647abf837cf46b567ed320dbc6f37193e622ed7f531ec0c9c1d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d87ef238e40cb2570b83f1bec606a13059361d6c6e15cda8c4f18fb6fea32591"
    sha256 cellar: :any_skip_relocation, ventura:        "752afc21f1b924e9a880ba9626fbf60ea6d3fa236021256f72d5dcf2b04c48f3"
    sha256 cellar: :any_skip_relocation, monterey:       "743c7adf0cd710bcc63ba504db4edba2917402c978e4549c7806349545900202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f11e84687843a89e7d8d590536b441ce0b7b7f3c53e5ab1fdf872a4d0cb060ad"
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
