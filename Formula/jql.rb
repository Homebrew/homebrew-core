class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.1.0.tar.gz"
  sha256 "b0e6228be3363ccfd7aa2400b253529768d9bea476fe6428f249a02925e2a296"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86638e25c6744346096677049683c65f9faf5a09c3180d16d9440a7ff1be274d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3e63350082c546aac98344ba90004cd03b91d51bceae8aa1a99dbd0450304e3"
    sha256 cellar: :any_skip_relocation, monterey:       "9c1ed92d693b42e09d57506558efbeac86331020ba0b466d428a7c45130c1a5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ad51bdeab3f3f6d2ae522d20259d304b3335a4874014b08ba7bf116c14619be"
    sha256 cellar: :any_skip_relocation, catalina:       "895a48427f4897c38d87e21148f88d2ce24dfe063fd9e4847585fdf1fb3a0cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44160d670a162beabe89e5f8b3fd17f3730ab832518bb41b5bc5adaa4d6f272"
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
