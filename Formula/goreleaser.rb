class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.11.5",
      revision: "11447a8990f8b4c95fc470d1fb83a79ecc1f64cd"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f16dfd4cbddeb08400fef93298ba1d0286261175d0ef367b1f7a8095a2233572"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd78fbcf604115832a72b00ac08b76d85a33ecc90c4d1ce999ca23d5494d65c6"
    sha256 cellar: :any_skip_relocation, monterey:       "62c4980439bcc37171a63f54f98fe3d0de01623a0b301e13bc952138f02ba66a"
    sha256 cellar: :any_skip_relocation, big_sur:        "12c079e272a2f272306ca884ca1153b618559a605d0f0c91314f964ebe9d9154"
    sha256 cellar: :any_skip_relocation, catalina:       "f38ceec83a86a88b475566855ceffd44ea2d4f0e6784a5389b25b3851f1d1b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a2d2ee601370dcc3a12630d42089cf6239f8b1828471dff607d8c0f4836162"
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
