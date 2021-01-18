class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.9.2.tar.gz"
  sha256 "0f3b9312e466ac78edf9a0d627a9956f8f9e03341a41e8b44626c5412bd8cfa1"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4626e89a15af443c0c93fe4b3af51c8c82744d32161680c70add383d32a954ce" => :big_sur
    sha256 "6b3e2d1bd56c9bba7fd196fdfb302268854e1422ebbf38ea883e888d2db7ca56" => :arm64_big_sur
    sha256 "bdd6c8cb7b67a5f6459960b68ecb28981daad3136fc913dfe4a4ecb9bb434d94" => :catalina
    sha256 "02f393c6b20beb8e4be1ee2bd45b8ebabbdab7c7de07672eb97b4c3994237a67" => :mojave
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
