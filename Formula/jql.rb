class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.1.1.tar.gz"
  sha256 "5b399fe48672596d32f8165df3dee52bf794d24541f46e5e90dd8b73c5e10629"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83191411f06f9c27ca9cd6d433beb93b60ba5057c8de9d839e136920eab15332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d2a6bae07a2e96e5e5d87ec81de99a7945fa42160652cafaba89d61529038f4"
    sha256 cellar: :any_skip_relocation, monterey:       "c85f9e15070b30617cf24c0de565d0502bb103aae0a778516681d39b9a36fedb"
    sha256 cellar: :any_skip_relocation, big_sur:        "bac3653cb33eed6f511cda30dd9f2bb61ea6b387cd6c26485a339fa077153437"
    sha256 cellar: :any_skip_relocation, catalina:       "fdf3aef90f2faa903a34ed9dc624a95c678b26ce91145d7b63783347437f55f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c235b45ea3defaff845d05166981b45d85bb41d9ccbc36901d28df3b70e6d1a0"
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
