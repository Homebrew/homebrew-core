class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.58.0.tar.gz"
  sha256 "2f180ff34e969880613a3cdcd6f2feb53af310180817075199690048d6e23af6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe8d0773ceb028871e0141ad80d53f2ecfd9c649f2a5e71cf948b00dc250e5a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b970e1d1fab31ee9405c057a2e2c1381f7a442c4f705fa129e71d51b4db8f6fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "657ed0717cf740e57e759ff554e3c3ea4f463a7b28b48af43a2c2e97f74a2e2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "655a9e4fcb2e676095e9314d12fcd95f81aef13190198e94ac4792a745b8fd9e"
    sha256 cellar: :any_skip_relocation, ventura:        "25d588a209abb3090cf50d856b86d36b8d3ce7d675c7f707b6465799b7771bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "00394a8382a6128b32a42925988b8f5f40a68a305c1ca3a64ae9e5f64f40060b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeafa4a450df0ebc18c47e10e41ef5e27576c172f02111f6453e91ba0ea3b752"
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
