class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.4.tar.gz"
  sha256 "db720310ff265012f283f9fdfb4ac99188bb4a3cbfe5550171c7e2ab55a36420"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de733f375d9bc4102ae9cc5df84b687a71f0bb1906ab7509ac0f0c94fcabe719"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce1fccb27a86677f00d118ca3f3a571495c57613aa35992576336f2dbbbc6a50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd1061f80d85c8e083b77b290fcde9b7b5cfc94a8b38ffd8a657cdb3f3c35c38"
    sha256 cellar: :any_skip_relocation, ventura:        "e1585c19d310ec08fa643b2e18d674044cb64968affd22b0fc1fd1f0467408a3"
    sha256 cellar: :any_skip_relocation, monterey:       "061426ee1e45f67667c47d3ae29ecbb5c132babec1e7588f8e8c0eaa8bcaf879"
    sha256 cellar: :any_skip_relocation, big_sur:        "d45dc50de51c3da6a21eeba921290cfdba1771dc6e4d54e8b618cb952a1494e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c906233ccf466b84826bb6d0f83dd08d5d721e305ddb9980c3648a0487d381"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
