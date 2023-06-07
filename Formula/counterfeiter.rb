class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.6.1.tar.gz"
  sha256 "33cde81680e6694da451862233e20270581fb40d3c490efb67c4b5e3a3ad885e"
  license "MIT"
  revision 1
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4805d187ac82131e2b3e40d2c4039ae4c350d2b13f550c97d2528ed2e5541079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8909cfcee1ffa290ece1ee980282d8b2d4adf26afbb8b564d6f92db1e71cb3fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1c60d6667c481be2435bdce9dd16dbd68d3de2dfae2b52d19cb478e76046b22"
    sha256 cellar: :any_skip_relocation, ventura:        "d9733648376ee08012007691095c563440debca5049da4b7443202bb5070ac05"
    sha256 cellar: :any_skip_relocation, monterey:       "6dfd611772dfce91fda225ab3d3beb32dd9bf4b4254cde116a9ac667f4e7787d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e199e420938cd08d270bd3f457ada00683e7184c56058331c06cd773fc8f153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2835f65e0865ccca3483ae6b0d7a7edae45eac549603f3885573fb3a841e8839"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
