class HtmlToMarkdown < Formula
  desc "Transforms HTML (even entire websites) into clean, readable Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "1086b066a17bf49d8bec8fa493e07a54580924ad866ed7e8052692accba706dc"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "890516745fd0ca1ad2392c147e8f7629b20535371c0e12eb44bf125a1ae1c6b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "890516745fd0ca1ad2392c147e8f7629b20535371c0e12eb44bf125a1ae1c6b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890516745fd0ca1ad2392c147e8f7629b20535371c0e12eb44bf125a1ae1c6b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cde44a3c2d177f08ca563da427e166d9cd4aeaf1d00cab95d179d0948909563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c3433f9c390f2cc6c51eb5115a26e3f83cde996cb2676ce4ff690192e5843c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76828ac73abe7f228159b2db84d4dfb1d59cea463a3bb26c9aa62173c0dd0989"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"html2markdown"), "./cli/html2markdown"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/html2markdown --version")

    output = shell_output("echo \"<strong>important</strong>\" | #{bin}/html2markdown")
    assert_match "**important**", output
  end
end
