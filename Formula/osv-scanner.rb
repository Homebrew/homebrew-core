class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bc0f3a0736c5a6b1ed4461541dd0c0bb6b64e03fd702a97f267c595eff5a3f23"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

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
