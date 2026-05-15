class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "9a4d8337f9456fa757ec0e4690ff720a60aef91ee64461ebba15d87def553da0"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4929bb9b66ced2e9b4ffdb0eb584c0debe2c37cd8f7a9a85ca401f4cb62dc181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4929bb9b66ced2e9b4ffdb0eb584c0debe2c37cd8f7a9a85ca401f4cb62dc181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4929bb9b66ced2e9b4ffdb0eb584c0debe2c37cd8f7a9a85ca401f4cb62dc181"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6f57bfb50954de53f8f28ebfeb200d77add29feba0cbac04d75420c7addaca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "413c808befb3fbc511af53c16ff19f4fa5aaae141dde68da70c5649addff9567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15802085a9c9844e61a7fcf77fcc581cf533647614413dc20198d3fdbb4730af"
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
