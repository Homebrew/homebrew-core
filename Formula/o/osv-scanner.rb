class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "cac90e2683079d2fbe7c5e387d6a5acb65c7d340153df06e91578f9212def50b"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "792e7ce252cc396cd2138af129f0d76c2c0da557af085a6b4a522a8d257adbf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792e7ce252cc396cd2138af129f0d76c2c0da557af085a6b4a522a8d257adbf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "792e7ce252cc396cd2138af129f0d76c2c0da557af085a6b4a522a8d257adbf8"
    sha256 cellar: :any_skip_relocation, ventura:        "7b19d81f08a5f5e3557d038acecd2f5ae4095856ac1e5640bca39da67a63564d"
    sha256 cellar: :any_skip_relocation, monterey:       "7b19d81f08a5f5e3557d038acecd2f5ae4095856ac1e5640bca39da67a63564d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b19d81f08a5f5e3557d038acecd2f5ae4095856ac1e5640bca39da67a63564d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a87a7bbf5008320eb1eccba4dac980ede6fea533724818be03b76dbbd91ac2"
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
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 packages
      No vulnerabilities found
    EOS
    assert_equal expected_output, scan_output
  end
end
