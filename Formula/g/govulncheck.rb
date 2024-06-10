class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "89f8412640e375899a6c4df7518005e121b9d37d5a6157bd4418cfa28b19344c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "921453f5951c515cdd190e206d587b06f60f74ebc4b33ccbef5048d9ee7ae082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c0bae2212d9f9cab07b047f299aa8c0bfbfa92bf0a77a2fdde0d0379b63a9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd3fd09d3a4234b11fc5e7ee5f8f2f3c71b7db7cb41867d6c9fbd06f0577f95a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5624c1fa68914248d2140730cea689f7a6192dfbbb32c8aa63bd9964be31a9fa"
    sha256 cellar: :any_skip_relocation, ventura:        "718764cf03b2dd3ffa6469be0dcb1e92d5e80a137e890afdd9c6c2ef3d1ada89"
    sha256 cellar: :any_skip_relocation, monterey:       "26284e03175e2d0ad850906014c36613e83f0e58ab920481fdcc2cc4e1710969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ddd2f249a5a1e8a6bba28119dd368351a270853bd8c614ca3cc5c8f0d98b266"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
