class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.29.tar.gz"
  sha256 "4dc02d9e7ecddf7364b1862d8b478c2a6f01e0eea9dd755e40e171c42d0b3511"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2c901408444287d125393f3c6e7b6f0206b4d10b74e7209cb6146f6d9561fa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d71d1c6926e7f2e34193148ecabc7043e6ba94978940b4ed8f3168e69bc2e95"
    sha256 cellar: :any_skip_relocation, monterey:       "9f6c2f49b51ab632aea436d383a6124f15b97299787e4796a0482622572629ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "83db09aba56d9bbe372f7958d01c00c0fdb3320971e49e439895d3202744ddaf"
    sha256 cellar: :any_skip_relocation, catalina:       "6935b23f280b733e62780ce79fe42ffadfcdfad2573be1565c79cbd4890123be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc57b32dc2fc5ab55e2227ee1233ca5717b9977e23efabea5d4998899eca3627"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
