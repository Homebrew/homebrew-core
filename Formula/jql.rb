class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.2.2.tar.gz"
  sha256 "4a593ea6b6c06ec78a9f3694f325fd0d64d218bd4cb3ee6e3ef892c0d88cc4eb"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c17d5c2fdfbe594dbccf86a417f7c3361562150dc1f2a2deb4cad9d2cc1f9582"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "877e5e989db53f1e95a174c05f2e7fa8242c10028ba5fd297e1f1f55760e369b"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc40b482bb13979ff1c229b2b293c846103d1de063a148327beb804f17bed8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb31e0539a0a7ac90066dc54382c05c45563f1ee7573fb4813f232618d612858"
    sha256 cellar: :any_skip_relocation, catalina:       "38b48ca2d27ac23069efa3910a5d5e389dd728d87cbf7f9cb21430440bbb1123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf5c43f38bd7409c9593e84ff4a139b2750cb2e57358fb4fd2f283d6042149ff"
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
