class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "33dcc4a5c03681018aac1d7f4f4772d0bf6a0d0403bc1c94cdead23db93bb4e1"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c901557413aa0acebe39c9e1450bcd1aaf511cd66c76e2a9c94f756278f1c572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e474f143c1d8df78576d4f944e75477ec66add448b72df1683c9a51d69e048"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2899a433df3bf69f8d65a148fded02e9a1a830842c4290d09bb5dab92468c7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf109aea2cf32fe7d950ea10763a9f5861b708d2861d942f71a2bb3f11815c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c333badb6b3ac5074cc9fb200614857a6eb5dcf3d1db6b03443455ff1e23567"
    sha256 cellar: :any,                 x86_64_linux:  "548e6bed019d0a0b0be5c2ab5691ce97308790a53ffc95d62d0cc7bf00bd753d"
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
