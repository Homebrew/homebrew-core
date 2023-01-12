class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c9e89ede6bb3945657192cdfecded355509d35eba39e74000f4e45f486df2c74"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "934d74524c75ebfdf5695900227522d76a43c7b605389ac54fefc4618a8909a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0c1e0f569656ca1f57e081e54e23bd1795821d2194748c21bca1c0ac1fc1e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebcb5a382d3d17ce402f868eb2976ef652ac5085412993e43488ffd9158083a4"
    sha256 cellar: :any_skip_relocation, ventura:        "5718c0d3f1ed8f214aa8d2fc14d20e0de6b93a8461c42245e96dc2f70f6e5ef3"
    sha256 cellar: :any_skip_relocation, monterey:       "674759449997e283712f4a073dad2547ac85d5b56b7cdc56eb9e4fe2c1396ebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a76ee29042e4831b989696e6cc1debb72f5bb0f3ac57ddf62082c9cae2ea958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c03c075cf046c77aca9c2e0be3619e52add2387d0cb921bcce7fd4a8f7b65ed"
  end

  depends_on "go" => :build

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
    assert_equal "Scanned #{testpath}/go.mod file and found 1 packages", scan_output
  end
end
