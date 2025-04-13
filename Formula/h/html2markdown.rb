class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "27d6f6bd8e261ba614079942b1bbd967264208f2269b2da12881ec3d594573eb"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c219db5e39b7af648e6f9c12dd8021f370d589bd3d160d910ccb501b12ef0d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c219db5e39b7af648e6f9c12dd8021f370d589bd3d160d910ccb501b12ef0d1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c219db5e39b7af648e6f9c12dd8021f370d589bd3d160d910ccb501b12ef0d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddf7d58c05a7ad768de1fd74b8d61b57af4dbeae9bc1a20075beb29b2ddde73a"
    sha256 cellar: :any_skip_relocation, ventura:       "ddf7d58c05a7ad768de1fd74b8d61b57af4dbeae9bc1a20075beb29b2ddde73a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c6f55e344d34154d3e48890c3c01057ab52b5c3fb3f816a0cf7fc834bf3ca41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbdad706da16870661eff95f676d348122cdb03589efa9989bf7085764e633b3"
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
