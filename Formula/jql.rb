class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.6.tar.gz"
  sha256 "d931301c920b35ed2943902e1460fcd5c71afccce10c4d334a410d30707b6a0e"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "528231ee67b6bdcd849be598591afc79e1b742677cc17b319b92e7d0dc29305a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c2fe9accfa14429df17bdca296c27b3ecd1e23d2e544fbfabda838f745fc519"
    sha256 cellar: :any_skip_relocation, monterey:       "6b76ca161080888af8dd49a6d62e0dd04a9a4d16a4846686d17c5280ba185da9"
    sha256 cellar: :any_skip_relocation, big_sur:        "20ed0b4d55a9eeeb47f8d235553ca3d813b312f55e4a96107ea9853e3ca659d1"
    sha256 cellar: :any_skip_relocation, catalina:       "d6f904576b1a4a6d8fbf30f356b3636e27699b5233b7ce69e156608f5bb6af46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "317fcc6a05ea2e9195f7d23c16cb6fc6a28b7b77f61699f902c88e2c12774feb"
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
