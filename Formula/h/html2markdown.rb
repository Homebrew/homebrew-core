class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "da15e96199bea9ed610996548f43eae19059edc364ac08baf107c0777fefbea5"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a979bd39a446e4ccdbe82ce8cba546a11428027d3085364d7bb76d0a631fb53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a979bd39a446e4ccdbe82ce8cba546a11428027d3085364d7bb76d0a631fb53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a979bd39a446e4ccdbe82ce8cba546a11428027d3085364d7bb76d0a631fb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "3896c1af68fd1b8620e07b56d1267b26131dc6394afd09ce9e327b00956256c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f57684eea0fb2d180cd906c028698e9914e63198c2f2bd0a6f6a6a648df686c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b58c38649b5226fc49de51bde36ebf59ccb258e63e6dc182aaea0f2d570516"
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

    assert_match "**important**", shell_output("echo '<strong>important</strong>' | #{bin}/html2markdown")
  end
end
