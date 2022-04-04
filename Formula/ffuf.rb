class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.4.1.tar.gz"
  sha256 "89b4bd4b3bbad7402d9c81d0d9f21b679c80d0a19bb9a190e45e395736058889"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3adf6343d84038a25dcbe9c184c8c03335dfca5be65cc9c43f031547736dc4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b321758985e783b5ab0a605c1134b5b4eeb06b060daf18536582247710480474"
    sha256 cellar: :any_skip_relocation, monterey:       "c302207ea855b2997a9d6cd8ed9478fe341cce2856917e89b397fc7c7b5af22e"
    sha256 cellar: :any_skip_relocation, big_sur:        "479517b3c6de780ee992656a510a700d5be719b98c8b8edb2872eee99da67c9d"
    sha256 cellar: :any_skip_relocation, catalina:       "3d1e560ccef4aef2b20be515f0b990c2d7775be501d1e7d7d1ded13d7e704ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f97d9b1af9dfcb5d981bc26324fb93a6f9a38f473a0a4d2820cc75fdea78f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
