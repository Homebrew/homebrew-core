class HtmlToMarkdown < Formula
  desc "Transforms HTML (even entire websites) into clean, readable Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "da15e96199bea9ed610996548f43eae19059edc364ac08baf107c0777fefbea5"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e981d5e00545a518711ac932cd67108ea14efe6a9f66585b68f274a830b6dc99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e981d5e00545a518711ac932cd67108ea14efe6a9f66585b68f274a830b6dc99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e981d5e00545a518711ac932cd67108ea14efe6a9f66585b68f274a830b6dc99"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee47b6c4ae135218396b7e4b38acfd2096158f853586bf6e5f829b82358648f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4544cefddf21f3e7bc6a4288bb2c74d9b247676e9327b898ff1292718c149d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3980c2ba3963118b9166de4bb4f1f23635c6d33060f145bb4d738f06d7aaa2f7"
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
