class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://google.github.io/osv-scanner/"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "acd8ebbf345a9a04eb299cb8e1339512fd4f2ad402f8f40972edcffa3eb45109"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e6182d28e59f75673d8772506034305c78aec123c836de69aaab698f9939f29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8eb1f9d874a3e991cd539cba03a279ffeaa46a485f4c55273cf1661be129606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9710f629c378b9889ec24657478cdea1804af3ac979a0a360eb913b60f2a3ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9531ccd8f5b46401982134fc0dfdbf68bc12113aa4369f233a66ffa897603515"
    sha256 cellar: :any,                 x86_64_linux:      "72dfc42b3183928e8be9d40f53df78806ba0303d6e3e69a55145cd0876d32fe0"
  end

  depends_on "go" => [:build, :test]

  # `test do` block queries api.osv.dev
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod")
    assert_match "Scanned #{testpath}/go.mod file and found 1 package", scan_output
  end
end
