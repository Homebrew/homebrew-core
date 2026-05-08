class HtmlToMarkdown < Formula
  desc "Transforms HTML (even entire websites) into clean, readable Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "9a4d8337f9456fa757ec0e4690ff720a60aef91ee64461ebba15d87def553da0"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a9148389dc9d798f2179634075e5a9ce03e275b40de6dc559304c225b56476b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9148389dc9d798f2179634075e5a9ce03e275b40de6dc559304c225b56476b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9148389dc9d798f2179634075e5a9ce03e275b40de6dc559304c225b56476b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0ec0cd26e7399d889af6cdc4c3c6a5dbb5d7e5d3f70d4d0e04b4133b4297f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2521b9d95d0cc45e536aa00a9305b0756830f4bd7b6c6ca8e2c472ea24bb1ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee389423f2c32f6593c87af28122ec98acbc59b9e8054849c20f49b45f895f16"
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
