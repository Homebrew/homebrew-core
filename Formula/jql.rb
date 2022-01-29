class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.8.tar.gz"
  sha256 "fd26ff64224c2d57b6325aa64bc30210240667f3a2a14d5c1297dc707d91340e"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf76df33ded11594628c00c0c1348a052f82ee18a2c88569c2b8ab2b78711b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18169e5e6905095ff5942cf5139ce8bdfa084e53e9dfcac8a48a6e1535a0131a"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe36ac903af5881e233681510dc476980903f74f73f48eec27ad904aed11680"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ff47c98ee26bd5374ce908ffee6f5f8e98b79260a42d435713c70ee1300d69e"
    sha256 cellar: :any_skip_relocation, catalina:       "a7138abb881566dc395d86f1210ad15b5474ceedf996c95d0282e138fe19a94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876f5cd7dcabdd565907d7e346c13cf6ee6f8acc9950b7c37c4d85c0a79926c6"
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
