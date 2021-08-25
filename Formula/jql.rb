class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.9.5.tar.gz"
  sha256 "2e8de01904794a864fbbc5ba8ad08fae503ad6c9102b2e96afd545657d980fba"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df623f3f71689282cefbc1aaea2b11690826d1ea11d6ad14696c30fab51637cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ef6864301c3199dd7c3b8e791ed68841e1694cf491c4edd2fccc919ce30b98c"
    sha256 cellar: :any_skip_relocation, catalina:      "1283c011a25f34eab396186cece7082a07fd52e899276d559696d2775fe797d4"
    sha256 cellar: :any_skip_relocation, mojave:        "04cf4d07e468885bb1f741db4869eefd11d79f426418f04dc12378179625b612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3852fbde8a9634d6470227c734f03d9547b3f1456f4e1d6942d3fc615a24060d"
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
