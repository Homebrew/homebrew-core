class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "28ecf93205aa06630ec81f0ab02f7ba49748a962333954df7d86caa9870e8967"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17dab91be7a59a7066197bc90d205937587d9fe97b9c4808e9d4125244e6fb1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "513a621a7ef45f66510127291f1387d9eea47abd05ce5194caf87d4b44b7e674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "513a621a7ef45f66510127291f1387d9eea47abd05ce5194caf87d4b44b7e674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "513a621a7ef45f66510127291f1387d9eea47abd05ce5194caf87d4b44b7e674"
    sha256 cellar: :any_skip_relocation, sonoma:        "23fcf52deecd56fc822280a3bf86424337d1c9bcd74f586f9f624b89ccd939dc"
    sha256 cellar: :any_skip_relocation, ventura:       "23fcf52deecd56fc822280a3bf86424337d1c9bcd74f586f9f624b89ccd939dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6914d5a12432cf75cf1bb83d2a4b2799914c1a806215c48ce72934bc9e304ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3a35f7f57829642bed4911abfac35cb26c39cce93f655f526a95db6758f714"
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
