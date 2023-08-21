class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.2.tar.gz"
  sha256 "ac3816e4aab33972dbf359de1df369ffc8d434af78638536b4243d6cecb55a79"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b55152728bebc040988351f0ee89e427d08141f76b5bb670dfa4a95f132a4f59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "715a0febeb26b91f7f124a642ed8f158fddd8895acfa7750c97cd50fb7a80435"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e1066398f0f5f549ee1cf9d291c205721c22e9b26924b04ea210f4b9116b42"
    sha256 cellar: :any_skip_relocation, ventura:        "69a46b25ebabb39469582743ebb210c3ebbdcc8230da8a2e973cf42bb4ac29cc"
    sha256 cellar: :any_skip_relocation, monterey:       "62a2bfcf6237abfb67562d3694e0d84188f990b90f7fcc2ee1abeb0802d47352"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc034e2aedf50adace772de9bbc33ffed6df45aa8ad90747e61b9cdf7e8e539c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ccdc1ba1fefdddf4ff1c2f2786a80724410dd4d21bf7a85007bc0c24612245"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
