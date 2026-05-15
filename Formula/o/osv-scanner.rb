class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "768e5d38a68b5675cd28a298e6d28973b29170743ae79f5de58be956be4a0c66"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c908a40747ea7cbd10f548d5f8edc32e4db31f6ae06a6b3016fb047de1b16c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eae4ee581c5abb4527366e9a01299acb1337624a8caea87590f3da5d412d42a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b752628540f57cc390eb4ac0944a790a112c96739b01cad432d70e4b51299f46"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d287434f2736e340ee3fb5d833e476d8619621d0c11bdec73a93f3f99d7f08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fcceaab3ebca098831b180e076c243e8a3eda8eab9e094b2daf4615683ecd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a8f8e99b621f2ef851017de9d6909e61cfdeed0262df7b21af7f11003a8e04"
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
