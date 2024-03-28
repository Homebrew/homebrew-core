class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "9aa9ebd72bcf62a377231f6b821d328ab7163d1a7eb39d7e9271bb6c7c01a3b0"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e38d0443cd1d3ec13c54de6e8bcb5d72f08dbf14d67e5c98dde778f7b881a050"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "598392e1f36380806ca59c33129888f12dcde5133046efd3426ad04343f13dcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7310e73f6cdf26813ee6a01ac34d536f6b4864c4fbefb14d38fa528f30dcd5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d643dc79efaa420f319ef621158eb3ca474c3a315769a632363f1dcf97cc67b9"
    sha256 cellar: :any_skip_relocation, ventura:        "1eb6e6624f994506966404ad3d0290945e5e7f221670126653697cd1a2c5213a"
    sha256 cellar: :any_skip_relocation, monterey:       "6f24f97db5f57ff823ff2a8ae7903088343e146026e3216d4222559237a08ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656a42a1dbb48947199b1cc73ca05d8703b52fec3fa9d285db2f129c7a04754e"
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
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end
