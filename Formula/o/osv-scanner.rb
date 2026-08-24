class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://google.github.io/osv-scanner/"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "9a81d802aa0c0f667f8a80a045d4bab058fb9d9a6fb21f5cf2f1ea2007f73eef"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b38c086e61a754e96a622895d606b532c4b88dacf08553c4397a36b241412203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c48d63bc1288511250d84248dc1c409f16f3fa6568f0c345289ecbffb8d2132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1d7724dd85cf6a8fa94a79f5af8d5e732d5a77245bd042c0b8ab7b5f73873b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ea2b74c31474db07378f4d30d841645f8f7548fde9f8bccea63036f57ffa982"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "667c29723932c0f2c0c34a280f9623b5ca366aa84d1cf4acd041418bd90e70d7"
    sha256 cellar: :any,                 x86_64_linux:  "6c33873116d524514d81be26ab404601dbbbc8b658fa773ee86378fa9d2d8630"
  end

  depends_on "go" => [:build, :test]

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
