class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "1086b066a17bf49d8bec8fa493e07a54580924ad866ed7e8052692accba706dc"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9837e483ac47f88dcb55da264bee277d3d79094040c1752e5cc8811bb3d4142"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9837e483ac47f88dcb55da264bee277d3d79094040c1752e5cc8811bb3d4142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9837e483ac47f88dcb55da264bee277d3d79094040c1752e5cc8811bb3d4142"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f967aec5fb97592ed02554fe15c8d9aad35daa2281cea7471caad1fe558c6177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "50cf2f7c118b6fd96604ba13396e4c2ad79e3ceab185047b393dfa9449ec0d10"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
