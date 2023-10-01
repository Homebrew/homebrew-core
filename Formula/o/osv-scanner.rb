class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ea306347840c0c24e11061b74d0045f99179d7764e944896b9137fa49352e903"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d42c1224892f1b163fd80d9bd55389ed0b18e322ffdcac6bb53838f81a5344c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14475967067e7e8bfd6a8cfb0cc9b18accd3b116b419fd3fa8417dfae9a57253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a34e1f2c4e14c160a217e38cd1abd2f62988f5f58d7bd75c1dba5d64a8783a1"
    sha256 cellar: :any_skip_relocation, ventura:        "5bd223824a92dc5ca16956cbd15c0803c26462321e6593190a5208cd7143a612"
    sha256 cellar: :any_skip_relocation, monterey:       "6b04439fff4d7bcb7eacbfdc30e527f56beb43845a3de6ba5b15cda1a305c2f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef93a169e496148593f2dc2b2573acee3c42d3ab40f9b696850cb49d3e53565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff5ecf39a0ffcb55eed6f745ac6fb1bc59307bfd577affaa766563f40410d5e"
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
      Scanned #{testpath}/go.mod file and found 2 packages
      No vulnerabilities found
    EOS
    assert_equal expected_output, scan_output
  end
end
