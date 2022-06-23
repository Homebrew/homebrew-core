class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.5.tar.gz"
  sha256 "b9a0b5180753dbfc45e14fbc0db8640989af83c447cab21a58a382c8fb139f6b"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e39fe172261808680a4408189948ab6f57c2aec327da517154c42bfbed15fbdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3985f81c1f1d3aa53ee38a5bfcc43332958485d71cb9802b4faf6ea0173beca8"
    sha256 cellar: :any_skip_relocation, monterey:       "9e1ffe6eae467eaf17d99871df5c9c3a2382717f8bb33bf864838c850f2659da"
    sha256 cellar: :any_skip_relocation, big_sur:        "442ba0b9abebf6df771e6c47711b69c1789792c17d7e91ccea233a540071f729"
    sha256 cellar: :any_skip_relocation, catalina:       "1ef2db8cc68b49a2bdf11417de20a488322b30d3bf3aac60dec585d98083485d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a7861b1065552cbbea5422ebbb662f9083cae18c1f3ed763bffc43ff9d2431a"
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
