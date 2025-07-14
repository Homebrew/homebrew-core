class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.27.tar.gz"
  sha256 "c7ed6b1a92f8b77d72d3a80eff62e00eec888e050fcaf52c8ba005531cdc69b5"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "827fdad77ee1f43eea3f0ffd4b5fd296b89cff417f263c61fbee7e9562067ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "711b0b6f6bed1981573fa9393f50f7a31cc6aca1f14485fbad467ade740aab6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc9b66f312dc4e03e93853673088189b0a2c9223e0ac54ee2b5b18e473ae6b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba32ef3cec0fcf7aad2031b6d0109ad96dfd9c445bec6216b1368947ca2de82e"
    sha256 cellar: :any_skip_relocation, ventura:       "c9fa07956d1a586e50be1335c06032716a9ad44ac70f11d507e537ce9f0caea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f6ea18b070da4ec1a05c34a6dbf46026495ac1123268f4c947bf8e8daef35f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
