class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.1.tar.gz"
  sha256 "fadb8341a97257b2ef19e9c4a01062d2ff533d92861963fcd7f0e14b61dd855c"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93ee669a0aec89017530a81e6d0d0a44b6633f4c1f9683499e3b4f1ad5e6684c"
    sha256 cellar: :any_skip_relocation, big_sur:       "f30ad627f9e08c1e922ec14cf8d6baeb23d58dfee3e2c23862ef2b973fba0673"
    sha256 cellar: :any_skip_relocation, catalina:      "00a092b02141bb0fa453a8110da879db8704b07df2dce03d9bd70faa1a6c13fa"
    sha256 cellar: :any_skip_relocation, mojave:        "5153448e6d1bdd2de3f5c2b3460dd24268523d16e0b84ee258f4c38a789a0f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d8638575de8afe7725f26907c1dd08da1a6ebf7f3fcaac495be92406eabaf7"
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
