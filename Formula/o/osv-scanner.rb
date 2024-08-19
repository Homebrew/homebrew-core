class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "12e62afa96359587e6fa0d0120ee5b950b51e0efa8509948b08349cb34cfe2b0"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64980ead9a45e3b1d87ac82e629e63334ef9924153c7efbef8754920dac74e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c43b6e96b0cfddd2d1778774b98c694764c1b6cf19cca22dea3329906d22e17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "948b8f776bf757b1a4261fa43bb52f4897c70cada6d451f78944bb15f56ae829"
    sha256 cellar: :any_skip_relocation, sonoma:         "4251ed5dcc5e8049771539a6c2477f25bae496a6141b1b9b01194c33da64afbe"
    sha256 cellar: :any_skip_relocation, ventura:        "0f7f087b84591352e7f9ae1d78c5f47daf60de7f0d8bbffc7eb886617ae196b7"
    sha256 cellar: :any_skip_relocation, monterey:       "a12fea192862ec78fa5f772bd8155fa4d76e32afd134aa253451314088223051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8c93d4e8b49e6357222312da4070dbd7d6bf8d4182b079da72a26392c5c4da"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end
