class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "65639a46d5447c704104ebe510e66bd155d7f3688bfced169ac9f8d424eb11f8"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec0b5b0100e5841b47900a7141f4a47459d3e3927647a14d12bfd36ce663239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b786d0818304dd011bfb94f03fc478a9e027d0366f0aa4a18663d00ef295d93e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f93e4581dcc5a08d576b87b41d092c08449778cc986876e1776a4512953b688"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5117ce555bbcb9b25ef5b49e4e4068ac5515c0f311ecdda62bc5d4c52bce989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1293bf69c1f5670974296468335fbd83ffb35b56c00dc50eb60f3252110ff61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea993eaf4168bcf51a247bbe37f65ffefd7bf48b17904dc05c6b2a1e4e627baa"
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
