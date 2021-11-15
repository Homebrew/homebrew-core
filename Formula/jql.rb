class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.4.tar.gz"
  sha256 "4d916c75184742b98c1df6b21641647b9150992314a8ae19940a44a6a65ade89"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02fe34f50bc92d3119e017a1e2b8c00fbf69d8135618e7c36da58636e76ef38b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b20de9e169918a6eacc431d9fb3077d3f745e895c0d006e61266e864556feeb3"
    sha256 cellar: :any_skip_relocation, monterey:       "4bae74313a81f7a96b74c1e378242cf4444fd7e8cc6d8d2f7735dad650f03251"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f574c701e1a5bbfc0c3cfb445bcab47e099ece7941f90f23a832d215a0921d6"
    sha256 cellar: :any_skip_relocation, catalina:       "59e2a8de0c17be47b53a2de3dfe81eeb662a253376052342e4a1c67c1d8f7df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819f270bb6ad8523bd1171036fa1d4bf76a7053667f9feca541fb7f23d2ed5b8"
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
