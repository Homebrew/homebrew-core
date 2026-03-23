class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "92eb4ce056d04fffbbaf6f4f3cd522e84900d12a4303edef6a3bbbb46a70b6c3"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d083eb689733cd603bc36735e925a643873d37e06e565542414070d95b917802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa54b80fdad2c2d7e378a8c2ffd1cb0ce8033fc9c66216e76c633bb30f372d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f01f9dc6299bf7cd796d21c951ad3157f7de1ba2b1072d0ba5284e7199e7538"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eba03af78c161fdcf55b01444371aa0f106bc69a446616d0dcaa650dc9d6431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4626ed4c7537da64024b443920f55500f496ac426e65aea7b97044830d8783c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f758ff03033757e1238dc71dd965d4702223c06488be6ba2ea04c1e99207581"
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
