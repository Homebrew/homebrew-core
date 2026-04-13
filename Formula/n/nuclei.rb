class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "aefa55d31d8d4e60cdb1458d33ac85ddd723c4046e6c82a8cc16e5d602b0a351"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "193a1757ca83ec7e002922b6487e1031cbc58a456a18e9adf18457f7952168f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff632277b40dd22fa9d3d327ec4d88b6b02af2271a38425412f0e4dbf6bb4d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb1a3f02dbeb4ae7091b602226195e2e797b7770fdf61a7c0da0520404b3308"
    sha256 cellar: :any_skip_relocation, sonoma:        "76d56731fafc65c71188e0701a9be63ae44c9e5e190730f96959f85cd83f903c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd8b26cbefe7f27d69344d6d2e41ac3fb7d875e659da9f6095972a41280b85d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d098d5456f49ecf4eec3675e72ebcce40bf6f4ca08f77a5301ff07ff327aee2"
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
