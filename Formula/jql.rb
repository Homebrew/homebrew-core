class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.7.tar.gz"
  sha256 "83ac87277c0aef4559fd330a99b4b462f4a2158180ef9204083e7c1ce247e344"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4185f2c3f63291f9ecb7420ea5b341e2d5ac159f68ca1ff4db576aa469174c65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8dfaf91041cfa351871d8f71ece7d72a885e208fd87b796ef205d6e23e367ee"
    sha256 cellar: :any_skip_relocation, monterey:       "69f5452d9d0785b0425f348de966254617f2393df31ef63d1fe036c21ccaa89d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4511c690e719aaab94e301350d672a27dd86987d910798305d8e3e46e4f7ebd4"
    sha256 cellar: :any_skip_relocation, catalina:       "ba142eae9af5d26d50d0354e26eaf901bba21f3ae1bcb5c7224da7d81ee00b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c77eb182dba44e39e9108de89a8ebd1732707afbc86161e76c4690223a68026"
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
