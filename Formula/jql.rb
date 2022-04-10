class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.3.0.tar.gz"
  sha256 "b605e06ac8f0967bbc0f0bb3a146ef20531f8df6c722a91b6293fc21f98bcb60"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a2ef1cc8e9058f7b8dc547b45d78bf66421eee38e7312586e728cd78ae5fd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "146e0d78be88ab1a31f746f84fbd0592cda7e1baadf628010dbb5b024b282876"
    sha256 cellar: :any_skip_relocation, monterey:       "d85efeeadb0c4b22fa643389822ca101866bbc3171829372b63c5bb1517521ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "62824a3e2c0cc521810a74d19c3738d54ca60b9dbce14807d6603f2e197a0ebe"
    sha256 cellar: :any_skip_relocation, catalina:       "6fef8e594c2ff05962f13c1d1d02af0652b279b81d81143a1fef1fe75e65285f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c223382723e7e1b4ac37a543ee82a76cdbb5ea4457d2dd8ac34fa7311781033a"
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
