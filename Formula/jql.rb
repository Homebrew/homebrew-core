class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.2.0.tar.gz"
  sha256 "89a04e2f8bc40dc1d5cc12a1264b9f754d6ae226e7184768babd5963d9bcfc04"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd094de28201074a791e270b29e50072777effaff30d094d16988033ecc762f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32a07cc3a15843157e7ed312f4c293edb9647aa4a618d160c0adab992e452768"
    sha256 cellar: :any_skip_relocation, monterey:       "77be6d3b8060792290d8db8ce171620a4569548c520fc0944c46e04860df7125"
    sha256 cellar: :any_skip_relocation, big_sur:        "843283aa4905f171cbcb91c83e62ebfbdea73b950f5d7fe951f5e29efc305898"
    sha256 cellar: :any_skip_relocation, catalina:       "7b0137bbeeb92a0d69ea04dccb7a86d10479f502d57524b5d810dd12ce62d7f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634bb2431b5973b1e575461f97946e12ac823295f9b11fa456f88256898822ef"
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
