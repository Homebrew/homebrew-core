class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v6.0.9.tar.gz"
  sha256 "90095880108b5cffa83d4849428835628e7e285742b38b2cf033e8960c508e23"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09594a90b33b32c4f543377c456c9bf2fcf2addd1e3a5eccd54bc4d2fb9cde0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d9c6e917d78c8b2be25442d425ffcad3728e32dfe298cd5f9c2e97f2159a814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3536665d9ec1d7da4109f96eaf3e30125ffc914272ebcea7ad879636623527cf"
    sha256 cellar: :any_skip_relocation, ventura:        "7cc0ed283b34d938c97f7faed9f5384a2479ba29398be8ae52c458a81dedcb6f"
    sha256 cellar: :any_skip_relocation, monterey:       "ba15f9b581203e96b602a7bc61c3959077f01018089747e36d5ba47f4bde93c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d43fb75b869912d41f0193d97928f62b802cf9c050dd94ad2b7ec7b8468b9740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ab33a929c742a58a61b9097464d7915078cb7aea9d6ff8bdec0ab8e56de2f98"
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
