class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.5.tar.gz"
  sha256 "b9a0b5180753dbfc45e14fbc0db8640989af83c447cab21a58a382c8fb139f6b"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28576b9487fe3b10d28125bc72808673381acfcd2b4b0200d5ff869008327f5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ddf844d64828f64cfcc8c49585dd59dadf29bf51e96d09ce08d0aade92e2ae1"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f1396b847a75160fce21f19f8b69ca9e029f2623023f0af0609be8ec71839e"
    sha256 cellar: :any_skip_relocation, big_sur:        "49ec1c4064ea1ab00e7522409866ffff867a6cb9d8ace40f750f4db71e00e065"
    sha256 cellar: :any_skip_relocation, catalina:       "19f21ae244fcfc147d7ec8f4a3d1c325d63a4bcd002f016be55b2cb1c4a470d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5349fe283eee91d9f3392cf72650c6042206db38b5beb093f77706bb2501af76"
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
