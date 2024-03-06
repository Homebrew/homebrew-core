class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "2e36bb23c87665e0081b1d3d538fe342cd27d041d864158d099f3c1a9de6de31"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94229fbce9beb84d125e10531b85a60e2e297c819057c688faccd06a42d6b299"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce0c3bcfed8f1a5fbf2fad129cd41af318be1e14a14b33e6482d2762aea0f841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3192043cae7684bc5056c8cb33c410adeea6b7acdc80a7d05692b2c7c856cb45"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5c10fad3fc19a5bd0145644af57885f2ffbc60db32d8ba12328d1b05df9352f"
    sha256 cellar: :any_skip_relocation, ventura:        "8fb7c1af5e47385d15cfd3b10f8b00fc1a447dd689e868834f6d228e203352cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c695e04d0baa00cf3da4cb8c2c967ebe3524277db8e575d1e547c7d35ad3f547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c62a267271fb1189b49dc4963431a8237fff04ebd59913443e45cd839c2ffa5"
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
