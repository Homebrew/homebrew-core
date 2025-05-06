class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "c419edd454980d7a8c7401baed04748d40342d6a77c1317696876986f171664b"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c3c1f4261ecf813b1110603f51d6b366e45942e0f507ecd7a2d9e5330d6127b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c3c1f4261ecf813b1110603f51d6b366e45942e0f507ecd7a2d9e5330d6127b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c3c1f4261ecf813b1110603f51d6b366e45942e0f507ecd7a2d9e5330d6127b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc1f27d4999f3fe9cf2ca8d878d32b2b8054744be8d2781afece1868953446f"
    sha256 cellar: :any_skip_relocation, ventura:       "3fc1f27d4999f3fe9cf2ca8d878d32b2b8054744be8d2781afece1868953446f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096db7ab35d07767ec68d7d6786724f05e8b9607d2d42815d0ec0b568d6f2554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a02d4253a8de9c56969ea49d09bfd04e53e1d632ecb4c3aa5d3c745e786515"
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
