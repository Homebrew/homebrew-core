class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "228ee980bc823adf21874dc4cd76c7832fca39b48fed4b9e014927889dd7051a"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "848529a838caef0f7a03d69fc4289fa3a1e766519c70e299cce9190493aa440c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "848529a838caef0f7a03d69fc4289fa3a1e766519c70e299cce9190493aa440c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "848529a838caef0f7a03d69fc4289fa3a1e766519c70e299cce9190493aa440c"
    sha256 cellar: :any_skip_relocation, sonoma:        "609c792c58edc801fd6552ee1bee627b9da665bd9fd702b55d1b065109ad0b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a42d9923244f5d79656812b9deaabbb80d952d02aa28fa08d2af96e605b4dc"
    sha256 cellar: :any,                 x86_64_linux:  "b08861a9bac8ac1adc4485de53cc01276752f0754833992e6b6a506229c468a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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
