class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.56.1.tar.gz"
  sha256 "54e4f3326be3c8fdd2263fd3ac9b31ea114c3c8d03efa6b928de33515ac41f24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c32e97f4c746d712e8dcdd79def8beb51c20387fc4886d49d0e051c4d3ed1fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc7b1a3d9c9cb987cd347236c3780e0f09fea923c60c80d342f449328d53dfa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04cc8a236008c8acf502ab57ad23b91d76610312aa29e134400fd2913ac06d49"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9b988f288806acc84411e47989e0b3cf64f3f12a3bfbf6e306bea7a2337d224"
    sha256 cellar: :any_skip_relocation, ventura:        "34129f0362e0d4cf33cd3bc88f2235220764a5887327bebbacd5c2a6a5fe3cee"
    sha256 cellar: :any_skip_relocation, monterey:       "a497d8087336e2f9124187279771df5784106ee71cebb4d5845b1e1bbc1dfc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bb39bba8c7349b54859f98452c4c20c3f200b48c491819655d651aa110b0b61"
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
