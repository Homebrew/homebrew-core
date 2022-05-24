class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.3.tar.gz"
  sha256 "8cb6e5a9c02c17d17d531771b901995285948882fb161e767e53850c6bc6da36"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9648bd261a0b3b9448731be1369d521ad513e04d73a1a436d4b3c5bbe2334e9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80a8e0d3db37e04d5e63e24661ffc75f29cdcc9234b3a08aa26c81088d510f50"
    sha256 cellar: :any_skip_relocation, monterey:       "8819d8a76e856385f9dffb83f3e5e00f71373ebfed798fd1c2ac79c3154e96d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "193f5efa89fff64e904b76e6572c04e4ccf8d8212a107b22da3b15848de08403"
    sha256 cellar: :any_skip_relocation, catalina:       "6fdf30b17cf1e453e510c957c931b39cb9c97276fcac5ff64d8fc1bbed58a6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aa47e91737c7d73f671d281b45e6b7f73b8fd39cd0b3435aac0b99452e53df6"
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
