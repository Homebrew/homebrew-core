class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.6.tar.gz"
  sha256 "85f91131ae1305e73f688441c1b053c9126b045ebe9a3cb4e51d260f409a1688"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0b5ac225d11da3f39942c7d9285e66d9d0370bf66dc3b672da4a0404c6894e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d11c0c83b938068b3763e2dc409d2672170a7cae6b081fdd27657783e9796be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c081f6452f46fbe9f9bfb49d13fb106ed6e0ab95b6fec0f97cb0c98267c1b258"
    sha256 cellar: :any_skip_relocation, sonoma:         "7763951cae7aaf351941f079d090db3d0ac5e744e508f4d8be5f09271c0994db"
    sha256 cellar: :any_skip_relocation, ventura:        "9cfebea7c563bc33c0f07dfd81f0466b484032d79112c6173e0a8e36a4894d64"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce767406a08f4c90638bb65d335ae99ed2282d69f5e055285da537ab3055db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5568a1762078d0306053036152cb415f3158387e5318a848232b00387ba8e6"
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
