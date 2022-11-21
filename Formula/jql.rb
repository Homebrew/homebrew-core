class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.1.2.tar.gz"
  sha256 "2829c134e3c258234a644d87793eb9416ca37069b255cbbce64b9f01982653ea"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4f282a622dde1b2ac4144b3a5d8f47f98288710386e8cc7f39b3a7db507a071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f317f2fb189a59f4424a902affeefeba931c68a689a4c578975e18f1751f3653"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dcefcb050de039aa9671cbb8cd72bab0c77698ac1fc5b381db1a0b4b3ba9487"
    sha256 cellar: :any_skip_relocation, ventura:        "08b009bc733d56b7e7d7a6b60cc56f85b5288ba21e14e1e6addbad59868dfa22"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e8f4c4bf8f6124308b3b76f23038340a3bda77113a4a796a05c18cbbc7f426"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9177f58e210bc23acbf08c12e48fdf5b93a35543e24e6de59b930b4d758d3c6"
    sha256 cellar: :any_skip_relocation, catalina:       "8cd53413acdbc9994180131137d48b9e53053c4745dc63a98176cff809f9ecc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a044c9a23e55a54b15613982fd3e36794f454a3ebcceff00bf48e9995978f9"
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
