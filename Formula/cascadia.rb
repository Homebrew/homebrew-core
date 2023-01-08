class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "64df164638843322f45aa6b736f2e4a6750b79514722bbb2a927707432bcf22c"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/cascadia --help")

    test_html = "<foo><bar>aaa</bar><baz>bbb</baz></foo>"
    test_css_selector = "foo > bar"
    expected_html_output = "<bar>aaa</bar>"
    assert_match expected_html_output,
shell_output("echo '#{test_html}' | #{bin}/cascadia --in --out --css '#{test_css_selector}' 2>/dev/null")
  end
end
