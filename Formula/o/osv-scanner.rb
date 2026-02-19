class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "05a87a6b658eafa473b2e08316491551d9402501f67a731043c677c435a12a32"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7135a93bf6e4c52226f9d1969205cf6b340a44130e9ee71cec5b0332c5260812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42316817ee5ae0379e27130716f783174778bbbb8083a16708fcd1e5c38e77d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446f7167b6f1c0842f8bab8c233fac46c4ef71b92d9e64ad091dbf4ef54b4fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d051856d0c1f149bdcde3ec5c9a6c930b5bdce035f5da917517f5ceedda83e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c14db6f806b316fe6da1817774aefd5c809d87607a11d5a3a254eb42809075c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7165ebe7bb97546ed2625120dd710e72e0d67b43a79123c63b9835399421a2d5"
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
