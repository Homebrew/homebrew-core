class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v6.0.8.tar.gz"
  sha256 "484d9973dd202f3f437feff8ba4b845bfd57b574dd96eef7c78b82c8148783ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dac064389fe5497d7472affddb4a3770e5b7c3db10c7d7297e0beb191029a907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2da3c9e0e478285a535756b873f0b6915f5988332cf4801bba10271993290171"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee1194381106567b274312506147ba81e3f92534287394722f46727cd1b1c3e3"
    sha256 cellar: :any_skip_relocation, ventura:        "b871e14f26c2895ba5a39f1fc0e7c3c7f6c22845f3e6584996009f1f63c08050"
    sha256 cellar: :any_skip_relocation, monterey:       "2dc123558ea8e722620503b9833e7efa79294cb79735d795ab6a507af90bfbfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ccaa9ad2969eb5af6043bca9b9c806ea5fdc5ffc5a41287e24fa7177aabc924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a379351a3881b6888616ff14f7cc5d02e914a7b0507523d2822f2f8cd9dad44"
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
