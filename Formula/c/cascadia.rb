class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "228ee980bc823adf21874dc4cd76c7832fca39b48fed4b9e014927889dd7051a"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dba506bea117226312af273d82012c809f484b88cbfd30d97307afaa84bf3b32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dba506bea117226312af273d82012c809f484b88cbfd30d97307afaa84bf3b32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dba506bea117226312af273d82012c809f484b88cbfd30d97307afaa84bf3b32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04877aba87ee3ff22fd03b5edad1e10b3039448cad79faa4fc2b2863a8ecc879"
    sha256 cellar: :any,                 x86_64_linux:      "81537de039f2ab13fd1b28e7467ff2625e7fbb3a16deed77f7c5faedee7d11db"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/cascadia --help")

    test_html = "<foo><bar>aaa</bar><baz>bbb</baz></foo>"
    test_css_selector = "foo > bar"
    expected_html_output = "<bar>aaa</bar>"
    assert_equal expected_html_output,
      pipe_output("#{bin}/cascadia --in --out --css '#{test_css_selector}'", test_html).strip
  end
end
