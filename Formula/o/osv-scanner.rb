class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "e73d5389825321685e9d349fbbb4b2d35f10eebe35b0a0e9005a6264a6d96389"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d42c83a7f6f16551c86c47aefd58ecfdf5318d58a947a9e901fd18bc484c0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8280026a587ccfba68dfb0c95f8a345dd95a45c635533bb731eab400d28a404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea0814b3f4a3e601c6e97f78199e486cc8f037b6a96d795dba56280257fdc63c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0934e1ed00c6edca72056814d10ec750123df984361d8c43a43c74c6b993c2c"
    sha256 cellar: :any_skip_relocation, ventura:        "4d9e81c8150d0ad53757035bc0a2c9e634689699ded2b5543b82d953df1e489f"
    sha256 cellar: :any_skip_relocation, monterey:       "fe90a25803252f240a3764fe748907ab97b571ded3f91b0f12544966e991bdae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40cff498c8ff6ece4c3c461e4bb9a197e71a7472a98eefeb07d106bb102db0fb"
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
