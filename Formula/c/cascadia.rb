class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "1ee285d683aa3956dbeb28cd9ee2c60f0ab3a5da8e66a98ca3fb718d3214b775"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "00fe59bee9982cea9cb64dbcddf32a802c6eda7b57d368413bca58ad720ebf46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c632f95d33e3db0a0ec037480cc5763b0d9d157588f0bbd921b886c42ed6c47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "506f6721049179118bea0514854909832198d552c52bb122f1648c17b91ab7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "506f6721049179118bea0514854909832198d552c52bb122f1648c17b91ab7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "506f6721049179118bea0514854909832198d552c52bb122f1648c17b91ab7dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "808dc91548c40f330a18db98b194dcd18d21462323040ec3342826279a50c137"
    sha256 cellar: :any_skip_relocation, ventura:        "bd7802721fdc17cfa6a5c99688899786c5d850679c83a3fa9cbbdb91a490ae53"
    sha256 cellar: :any_skip_relocation, monterey:       "bd7802721fdc17cfa6a5c99688899786c5d850679c83a3fa9cbbdb91a490ae53"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd7802721fdc17cfa6a5c99688899786c5d850679c83a3fa9cbbdb91a490ae53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "526b3788f4ac0884adfd8b6603bb0e8fe5719d77cca281ad5846b45f3c729106"
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
