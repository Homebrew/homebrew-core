class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.1.0.tar.gz"
  sha256 "7eeb73c76b39eb47dd8c7ec7af9b225e8c92da1d3dd704c99617d9331438f1a7"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ce102d60f8c9611ecc22e8e8e0d0a29b1a8de4a876d51465ef258c4cebeb82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f9f3ed8fff8c2ce34d445c61edaf79de51ab3668c966b03215dc5253fc9d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "4a71d08be88dee6075221f46f0e16863f2976ad82f8df0fe57e50f1408760c36"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e5438eed53f8c76b6f838747ed166eddf626fe8f059c7af0d17a5bece427cb"
    sha256 cellar: :any_skip_relocation, catalina:       "15005cb2033d052aa3adca59ad48925ec1f22fb6dbd464920154a3cd110b0004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c749a73995fe80c4fbef9f721e1ad9ea578b0638bfc96e016a27bbb6c4e0fd"
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
