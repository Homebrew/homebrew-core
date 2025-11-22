class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "64b1df1cd7c5c6f8508628fe2ead1969bd9bcf5e3d7d72b3a61ceab8ccae34f8"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66bf404fe146bc688ec5f8f11fa00007bee9748bdd037064129ed637ab2af44a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08877f4f981ff51f567891bd0b93c0b7e1031ae8d1c9874622f051af3a5e560e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "457131d3bca1cf35080fb5e33aa190b8068f43c20b64294d82ac952d52c8dadf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c47d6da48d19601b70d40bb85e23fc460da1958401219cece3741b7c16a2b88e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71c567a08b358d6282a648fb2a1f1e0530f19fc51c7ff6f899e406c749dc26af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48d09bab40e22ef4b738c883cbde6a38c06c00d25f983058d5d0bf5f2d655040"
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
