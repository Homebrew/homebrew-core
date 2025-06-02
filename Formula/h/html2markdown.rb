class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "4087f3626b5b2870fa491e58d19438cfe68ef8cfd61ce2468b759ec785c0ca02"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af127ee9d2c7d801f6b3f8be67310af5020dd56ba36e5ed773d723293a49371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af127ee9d2c7d801f6b3f8be67310af5020dd56ba36e5ed773d723293a49371"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0af127ee9d2c7d801f6b3f8be67310af5020dd56ba36e5ed773d723293a49371"
    sha256 cellar: :any_skip_relocation, sonoma:        "282a7afb34d97435b007ebea0aa115189263c877ada23f233d49ba20f6c6fde5"
    sha256 cellar: :any_skip_relocation, ventura:       "282a7afb34d97435b007ebea0aa115189263c877ada23f233d49ba20f6c6fde5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1830efb4694d844aca450a73286954e6a3e9cdde9830f2fd66aac9e3644d23d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc59b7de7a93f2737cedf83313cddb20d231d5edc33d59b396901abe9502141a"
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
