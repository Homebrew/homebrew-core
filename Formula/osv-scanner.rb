class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c9e89ede6bb3945657192cdfecded355509d35eba39e74000f4e45f486df2c74"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ea8e85bd0024f78df371f581383e5726f5c17c7c467c99823d28f3332241daf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a424f80a1d6932b133e636300aa7303d936418283120194ecf5c05ce1ee6e97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1fe48b52afa609aa4e620c53efe1e61150b75298e0008617072c8b822f0266d"
    sha256 cellar: :any_skip_relocation, ventura:        "9f9d6dc2eb5a1220c097f15267a6ebe80549d7c35f7814477debcd3eda1134c6"
    sha256 cellar: :any_skip_relocation, monterey:       "1d60a15a9d041e16f62e9ad0a24c076a9bb9fd1f5d4d51b38d24bb4a7a7b2649"
    sha256 cellar: :any_skip_relocation, big_sur:        "421de2562928c52ced1c57a3b302c6c1b0a547649f8e3c048ffabdaa0c278cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3924726e4f57d43217ac23d92ec7b49d75e71dfe4c494e850b7df2eeeae3f0e5"
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
