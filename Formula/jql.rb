class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.1.3.tar.gz"
  sha256 "f47f05a373135f63e8e8cbfbc3d743fd25c0d78ace2584a8c051854296dd7851"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a52cd1fd8839fe7e3cf7ca3b5650c8019624d0dd0d5cc52b2a37143b6a3b0d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "522b7fb80465affde9f33d2fef7c74df0fe7d67350280a255fa3eee6da3b399d"
    sha256 cellar: :any_skip_relocation, monterey:       "6abffe6b05944abd3f10f3ef1ffd5da70023a0843d805f558c8c87112d792bb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba07b09e1dc7779002f6d3d28f9785c2695e4f5385a93d3888473412b06edd83"
    sha256 cellar: :any_skip_relocation, catalina:       "bcc2b8141bc83893a9766c5c33fc65f9b1deef2488b4efa2c23b6061e727089a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c091679cad2f9a8a984cc7ce68ecb0b20836f0c780f8baf716637210f1ac953"
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
