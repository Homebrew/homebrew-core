class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "ee8aedaaf953cfc13a842decd11c28cae1238014275828af352b6416826d688b"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c0cff4085e14b9788065ffbd7c820f6cc9fcac268e06e49b2c12d7533affe2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b2b5f86e9b5477e4fb0b3429292d46e87cef55ba5e51bcbbb00b52e2811f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b8f6f0510e0a2423fa0df587f50cd084f3e78d53c3f4ca5c120f67004695037"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eb34806e5f182a1175bc8a91165d8faf5beefd7759e0abf35e080b99396c5ce"
    sha256 cellar: :any_skip_relocation, ventura:        "8a6b9bf45abddff8b9baa7ec4bf2279ab82a6e8928ee1b455087e69b5814202e"
    sha256 cellar: :any_skip_relocation, monterey:       "48ea171313b7ebe9312cfd3070a7d7e186d3a97bb3f2ef763e9387a7b611aa1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753c871ed86b6714c1a619ab202116602117163a5e9bda72e0248c237d8aaf31"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
