class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v15.2.0.tar.gz"
  sha256 "d745df0a437e31b4f66765b2a631cd73d31e474be85e98c728ef4c1c105a1bb9"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dad4da391e6a1f4da882060708dca73782265472632a6b58a1653de214a09dc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad4da391e6a1f4da882060708dca73782265472632a6b58a1653de214a09dc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dad4da391e6a1f4da882060708dca73782265472632a6b58a1653de214a09dc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7b86e1e2b8734cb55f42e56b4bbfe943321c6c9595ecde62b5fe6248698efd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf4a022d033224bf20b549fe12982cf4785dac58ac0690a188ff07c1e0c7691b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad76bf6ab90e0a11f201eae370a6acec8886da06c2bfd57c855ab18705bea330"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "FATAL confluence password should be specified", output
  end
end
