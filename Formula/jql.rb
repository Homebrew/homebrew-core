class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.1.2.tar.gz"
  sha256 "d7898d0112a9c35017bbc06192b675a4522f75195e3249a8127a413cdccc4374"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99786c7d5c6519fca8dc418aeff226b223ec19585aadb4bb5e9f00a7e8a2c866"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1d19337bd8a1f383fd2e28fda615aa5e9f8e87aeb75e1796544ff2b5033e98a"
    sha256 cellar: :any_skip_relocation, monterey:       "f640034b73b0c9e0757a20d799f65a3c761587b7accbe296297e12200eb54d96"
    sha256 cellar: :any_skip_relocation, big_sur:        "fce39c198ec89ccbfc42401743e293a15a50dbd0abec6472fff3c295d86fa226"
    sha256 cellar: :any_skip_relocation, catalina:       "f7436d3de3ab8837d73972baccc531f316bc0c34c2de503d38721e03b93d6ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441a7fe827288d5c9a201370e78bc5e015540eb14516c8c012b0f82a3563e99a"
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
