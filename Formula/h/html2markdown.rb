class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "bb7d3279445c2528e559322dea1f03c3fb348dc0ca47973ce0974809ca88c5fc"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8daf525b9a981be08c65882c5599ebba958df03d67509ae178e695643af711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8daf525b9a981be08c65882c5599ebba958df03d67509ae178e695643af711"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d8daf525b9a981be08c65882c5599ebba958df03d67509ae178e695643af711"
    sha256 cellar: :any_skip_relocation, sonoma:        "e978957819f668e625e7c8deec0742125f50da04aef584f966704b0f64e74876"
    sha256 cellar: :any_skip_relocation, ventura:       "e978957819f668e625e7c8deec0742125f50da04aef584f966704b0f64e74876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b25ae62ee053448efa1cc4179bc88c98702d2de7d4d4062833da810c9142800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cdb63e2d006026129b22b42ca38682b761e938086a457a50eac7d14dc98a931"
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
