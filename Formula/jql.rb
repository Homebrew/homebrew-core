class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.1.7.tar.gz"
  sha256 "e0bb7e8ac8e8776adacca694603acd9efc35e76315c4aa6f35ba9641d3967a89"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "007c8e3402419debf93c2543a0928c163dfd294fcfb80be1a8cea0bbf48b5da1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fbd57c80cb4e2526e27d1559a76c85cad95064a8218203493aaeabaccb47325"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5893c26da04061237657239834af3f34e3866ead031f5a23f2ae7a75a150a01"
    sha256 cellar: :any_skip_relocation, ventura:        "5fb6ea60b91f48affd9ab85f9cf59dbdcc73de31b80af3759070f0a89234d719"
    sha256 cellar: :any_skip_relocation, monterey:       "db165a264bd67bb49cd8ff857f1399e789d985e61b96e9f2910f2fc33fd34dd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8a65645dfd456e1c3ebf2ae62d227b3ea7127fa5e5ca824d88c6e5c9b2806d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d42c4db8fa0ed0b8982e76498c25f0c16b20d49b048db6346055d0c37ae12b1"
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
