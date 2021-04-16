class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v2.9.4.tar.gz"
  sha256 "2de36da4dc3e392b89c3ed2ee548691165428b0ec9c49109b26abdc32d3481cf"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63dce98e6556dd78dee89e63b1df945e233db792d512092592273637b313869f"
    sha256 cellar: :any_skip_relocation, big_sur:       "c30ec882f26770a6a4fc6ffa1376852c419de7677ad0d9ad1ed91c449216ea33"
    sha256 cellar: :any_skip_relocation, catalina:      "c70d279d1793d9533ccde351f39b3743fee779c870d54f88dc8826bf795d166d"
    sha256 cellar: :any_skip_relocation, mojave:        "b15e828c178a857c141783d52571e879f417247d83eaea7547e3f6ba441eab25"
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
