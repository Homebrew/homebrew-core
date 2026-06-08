class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "1086b066a17bf49d8bec8fa493e07a54580924ad866ed7e8052692accba706dc"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2741a60d7d49c4519fe3449fe8b27675f590b4c24496354c913653a1b2af61c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2741a60d7d49c4519fe3449fe8b27675f590b4c24496354c913653a1b2af61c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2741a60d7d49c4519fe3449fe8b27675f590b4c24496354c913653a1b2af61c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "49fcdc6a1b50c7f2ae29372ff96b078e32f60fdfebeee1a27306943b18426e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4be3c3ca3b3138b0deea80daa287c3fe0b98beb401869e586b77f4a48dad648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c65e2a0ca5484ae9e6d9532ecd83a55e645c8dcaf81652c3d761d27a56e2000"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/html2markdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/html2markdown --version")

    assert_match "**important**", pipe_output(bin/"html2markdown", "<strong>important</strong>", 0)
  end
end
