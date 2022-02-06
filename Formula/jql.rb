class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.1.0.tar.gz"
  sha256 "7eeb73c76b39eb47dd8c7ec7af9b225e8c92da1d3dd704c99617d9331438f1a7"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f23b7135a99a8be57324b118d3031401ed6f87b9fcbc1de5b9e030f17e68f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42012d5573eaad9be80a22345db834b761e7b5528795da736bd68bc8f9662c1f"
    sha256 cellar: :any_skip_relocation, monterey:       "ffddbc9e1416eafab6842989187d6e9556732b8060f6dfb7362f298b70c08775"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcad1128efe6a75adb4549b11c664137b68a0ee95a26663f05c2de66f322b4b9"
    sha256 cellar: :any_skip_relocation, catalina:       "c47383bf417c5428f2276eef508599332b906909560b63c40f98eded895ec281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96afcf83b84f585136d3014a63fe1657e6f2ea9086102f4b47830a45aaefe26"
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
