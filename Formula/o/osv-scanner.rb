class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "f6e6f6265dfbd4df87121c9d3feda8bd6d47ff0de98eaa773999df0bc8873f2a"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17aa8773cd5ef70bbc16a7e18df7023b68c4cb54ea6803296545d617d4317604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c0f8345b5bd7cefac27b2484e5159df3fa3a39e75aeffa4c13e6dfd694104c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650c9ec539d73e9099fb9f951d27cca4868d6f6dd4fc3f37a78190470ca15826"
    sha256 cellar: :any_skip_relocation, sonoma:        "80c4a7119ff06c7180d749275f8626d0aa80af5e65aeac397b28243380b753d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85404a2317e205e00a8849736c8fbe8c206dcff340fd62afb50a3e0e9cb25e57"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end
