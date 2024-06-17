class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "89033304dc19bdab6c278d763ce06ae0b4f4d3175603e163c052f14ca5fe8140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57133fd1749be55f8e11dce4f6b17516e1b5be944ec4bddd126a2436e76c5a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "377066de46c08b3eae2d3a1c60f904b4d73be089b900da65cc290fe338c6df2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d307295e50aed1bb98aac9e622e8ed3fa2e84e97373ba4e5232d2183c4003965"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6c45815d14726f7a8af9defb1affd191b9d698630d263005698df406471e307"
    sha256 cellar: :any_skip_relocation, ventura:        "28142e6013933551bc95b57b894bfd90c5c3969e2feb962c81ae386d00817f93"
    sha256 cellar: :any_skip_relocation, monterey:       "5f8dccb8698a38d240e8c570b98a8f08f29284f15e01d2461f94609e0a2da0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "323c297d666deea70b5db0ae34d4e90f82b4befe20e087f6c292f82432d6700d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_predicate testpath/"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
