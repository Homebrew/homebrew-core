class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.13.tar.gz"
  sha256 "b6bfddd3abd158fb956bd84995add3c715f2a5688aa9f9bfb5aef7ee73e4d8ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43dfcc13ee052a311a5c0bc52e804c8f8daa7ea64e85986515ca984b3600d97d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43dfcc13ee052a311a5c0bc52e804c8f8daa7ea64e85986515ca984b3600d97d"
    sha256 cellar: :any_skip_relocation, monterey:       "6d0fc585e502beaac8094e45f4eaf2d31c57f1d82fd0a1d62d407af4fdf7e776"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d0fc585e502beaac8094e45f4eaf2d31c57f1d82fd0a1d62d407af4fdf7e776"
    sha256 cellar: :any_skip_relocation, catalina:       "6d0fc585e502beaac8094e45f4eaf2d31c57f1d82fd0a1d62d407af4fdf7e776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9aed82da2d4f6a67c33660628205613a9b6a6fbaa684bae44e572f300cf103"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
