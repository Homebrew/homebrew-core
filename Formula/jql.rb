class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.9.3.tar.gz"
  sha256 "7115dcc3bf26458b5f55cd2af4e81bb68a8dda01ef0e3a707013f9fef9887022"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ac4ee4d58c7c60ca260f9ed69f210f6e73149be8b8b9d571f01986c6fae2d60"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f5948e6b22235f43c23bfcdeaa8bfcb9ab238b1ce7050f455f6416c4d9b5b67"
    sha256 cellar: :any_skip_relocation, catalina:      "d95e93bea9dc17026e5033482916686a87e22a80035c387efeb17bcc8af48c2b"
    sha256 cellar: :any_skip_relocation, mojave:        "b0e27ddd36efe3fa14caac8b3096e3408b4406af2cda72a7b0bb66a1f062d060"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
