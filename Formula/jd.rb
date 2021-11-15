class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.4.0.tar.gz"
  sha256 "9b1547b3c34652c61944a59e1449b8f819f196b86808c006e85ae8816d6c4d06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbe7f59b021be2377184ce2bcc066d0d8100bf2c6c1120dbbb4fddb5d580b6c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "567d80b08b78a787d813f8b5fc8119c60d082e7bfa2f641b1b807a6f85a69286"
    sha256 cellar: :any_skip_relocation, monterey:       "b6e9746d8220b7c916d4a3c32ade4deb56b2fac2e358323554070d8a4b792ae7"
    sha256 cellar: :any_skip_relocation, big_sur:        "043e88ba4881d02947cd922f8be0d26d581afcf1b877d433f8bb2f53e724a245"
    sha256 cellar: :any_skip_relocation, catalina:       "bf662b680167c6d28e9adf4d28ac35bb13fe6838255b9e6d4cf49be0a05cb920"
    sha256 cellar: :any_skip_relocation, mojave:         "c9a9b7acbab08f9717cf464bf2b00d970728d014ccb738fcb28af7502e8ef6d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13f39befda423ade478d2c2ea55b5e408cd45d841d87af81d597e6c93438a4f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json")
    assert_equal output, expected
  end
end
