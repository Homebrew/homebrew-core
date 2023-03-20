class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.45.0.tar.gz"
  sha256 "8c4cc0ad50800d6e5705d768e2ad1a32ac0a4a44318102fd8c1198a59422992b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eae0b71036320a077b8eebd6e6261ec2560366ebda92d15daa4836b91745886c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "059b1ced1319b42aee054f25cc79b7d696f38f9f8972293a7d050acbf802ea68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85a26633a6e28b82844ea6e29cd3d2b9aaea242df8edfcccb912948aed062090"
    sha256 cellar: :any_skip_relocation, ventura:        "0f696008d2d1393af42119a8a04554a364fc3cf578c4f328b07292b406ccc38f"
    sha256 cellar: :any_skip_relocation, monterey:       "51e89846ec562e7803e65c6fb088b70947a464d96fbe2bad57ec721db8599c73"
    sha256 cellar: :any_skip_relocation, big_sur:        "227a2ae3e788de9ad1f76e5879e7ef210cbd93279c0c02efd6b026df204bda38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37df192020e7c7fbfcd8bdbda42576c43131a9f68947e9ec8b53261ef2089c7"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
