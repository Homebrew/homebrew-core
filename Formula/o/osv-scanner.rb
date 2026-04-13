class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "b2238a4b417d2ca3e74a5937dd8e57a26866da9f9c4f764f1aa627a7779ac4cc"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a81f29f84f6cc235fdaa0285244092232b0324edd358284ac15c9cacc2943a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c46b0a99fc501ecf4f79774c7c894c5788a04de88b83e7563725c8b17550a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fdfe1c19b9c532c9dcec95fe03524e97bf11b6c11c7e60d0f024a06e0121e2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1897bdca180d26b5fc2c4941de239e9cc84c10c33127fbcfc118ca5e1698e6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbac78c7612895a496e1a1bd14ba1ba6ac97261b3a553dfdb9afda47b5a128a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260c11cd26b784435771d1f637beae76bec4f9250206fe0bcbd7733588dc45ce"
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

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod")
    assert_match "Scanned #{testpath}/go.mod file and found 1 package", scan_output
  end
end
