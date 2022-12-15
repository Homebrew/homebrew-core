class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner.git",
      tag:      "v1.0.0",
      revision: "c6ed0fabdbe8ad75465bd7eab81ba904a9c89f42"
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
