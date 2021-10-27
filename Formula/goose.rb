class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.3.0.tar.gz"
  sha256 "4c0e157c2dcbcdede7b219fbde783a94eead12c988fa6f756cabbc4d46bf3460"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b23455b2a38c5e1318939ef9775b121663729d08f0664560142e771475e87d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cc87dd72bba5a6e99b886ec22778e715da44f26e5461cb5b03e6cc1f89f1875"
    sha256 cellar: :any_skip_relocation, monterey:       "34072153b1d2d4d3acb1aa60fd8a2e06fac82f1cb7f5e25059fd47ba0f0d79f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d710d20027cae2c5ab8ad936e152bfda971f1f5e8cf7575e5652a40e65c5a1c"
    sha256 cellar: :any_skip_relocation, catalina:       "6297665dcf212e48d096052abe9dd1634a467477fe6a18c4747e5f64871e492a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33edc8882a1580439301dedfc015e84a9cb9a8960d39800aca25834e2c7160f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
