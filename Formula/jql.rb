class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.8.3.tar.gz"
  sha256 "fed30927031adaf4f51b78530cd811001c5dde3fe60fc3fcac4e16aef2589b2a"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46588e489c987d107a9c089673a80de31972f83e879566d8064ba09afa2d4e06" => :big_sur
    sha256 "98aa864e495a17e4746304d6d8ba602cb9c3ffebde12dc6937bbe9e576a8a51a" => :catalina
    sha256 "9cf16356d69554077542a655e458fb449f15600a13a09a5227c5e9cc1fe3001d" => :mojave
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
