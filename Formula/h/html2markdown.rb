class Html2markdown < Formula
  desc "Convert HTML to Markdown"
  homepage "https://html-to-markdown.com"
  url "https://github.com/JohannesKaufmann/html-to-markdown/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "6d45930df912143f7f8bc8097e28f9c93f39d733e7536a3801e294abbfe7eddb"
  license "MIT"
  head "https://github.com/JohannesKaufmann/html-to-markdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c49578941f00d7f66318cdef1ece3d09b9cced00e27a76ac7bde1b9db6b115c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c49578941f00d7f66318cdef1ece3d09b9cced00e27a76ac7bde1b9db6b115c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c49578941f00d7f66318cdef1ece3d09b9cced00e27a76ac7bde1b9db6b115c"
    sha256 cellar: :any_skip_relocation, sonoma:        "662ab7768938a28f8135a1f4f3a6d6f2f218b1c2217ba73b78df0a6b9d51d0a0"
    sha256 cellar: :any_skip_relocation, ventura:       "662ab7768938a28f8135a1f4f3a6d6f2f218b1c2217ba73b78df0a6b9d51d0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca32e272b8621aad6ecd4572399e61d614d2af2dec2157741f31203a3fa672b4"
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
