class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "674d32db061fdab3329cda23263f0ff2a8551b64d49b4829cff54912bd8befd1"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d9da8a8796edfe3ae5b6d9c71d48bc856588bc9152cf6fec79f3eac3f53b636"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9da8a8796edfe3ae5b6d9c71d48bc856588bc9152cf6fec79f3eac3f53b636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9da8a8796edfe3ae5b6d9c71d48bc856588bc9152cf6fec79f3eac3f53b636"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e86283adf0af56ae887df6c55967a7b03a62544b8f1b914e4b1d7d1b5ef57a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f89dc57dc214953fd42f1651546cabf331f4fa5d06c5e5ff91b62f7e5ad998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a08db3834543b4f96b07377a34ca4203e5e7c1b6dbe73674017aded43b91e6b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
