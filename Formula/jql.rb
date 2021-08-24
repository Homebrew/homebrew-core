class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.9.5.tar.gz"
  sha256 "2e8de01904794a864fbbc5ba8ad08fae503ad6c9102b2e96afd545657d980fba"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63dce98e6556dd78dee89e63b1df945e233db792d512092592273637b313869f"
    sha256 cellar: :any_skip_relocation, big_sur:       "c30ec882f26770a6a4fc6ffa1376852c419de7677ad0d9ad1ed91c449216ea33"
    sha256 cellar: :any_skip_relocation, catalina:      "c70d279d1793d9533ccde351f39b3743fee779c870d54f88dc8826bf795d166d"
    sha256 cellar: :any_skip_relocation, mojave:        "b15e828c178a857c141783d52571e879f417247d83eaea7547e3f6ba441eab25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16faa69a8b4f1123707c5b8baf9118f11418ef9e31ea84c9d3d8cc808b55875b"
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
