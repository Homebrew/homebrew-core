class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "ebb7f5017c6fe0c9aad25c520a44ac32d0424efb75f87641f66d5c2ef4fafe1a"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "226172ffbc9ddb4f34c8003fec05a62da7491302b4d5aa6ee6c2dea5647f8afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226172ffbc9ddb4f34c8003fec05a62da7491302b4d5aa6ee6c2dea5647f8afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "226172ffbc9ddb4f34c8003fec05a62da7491302b4d5aa6ee6c2dea5647f8afd"
    sha256 cellar: :any_skip_relocation, sonoma:        "868649b3842576c0a91f310ddc62cc4c0a56d8c6d854cf08ef2807bdc7e7c34d"
    sha256 cellar: :any_skip_relocation, ventura:       "868649b3842576c0a91f310ddc62cc4c0a56d8c6d854cf08ef2807bdc7e7c34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab7d906de15d19e94eee63d3bd56f92a5e6d58f6e657811bf35ecb104ca1fd3"
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
