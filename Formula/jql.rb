class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.9.2.tar.gz"
  sha256 "0f3b9312e466ac78edf9a0d627a9956f8f9e03341a41e8b44626c5412bd8cfa1"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d28b652abfe40c2fe87fee9c6456bd0503c5dce909936b241dd203dc17c3a19"
    sha256 cellar: :any_skip_relocation, big_sur:       "c19bf87a9f1d36b96100191ac0eab6936f531646bcb52ae92213088cae70820f"
    sha256 cellar: :any_skip_relocation, catalina:      "996fd5b3d1f5020ab3fc1730ca089f9a4798c46c035b014053b1213ee6bdc34b"
    sha256 cellar: :any_skip_relocation, mojave:        "8692fdf225aad4d9380f0574ee558c8c65c22916eaeedd15fc2eb6de695c6e17"
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
