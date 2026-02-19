class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "ade99ba8e6e5c3c3b18d7989a96244c73d4303eba6d8c6c3045f14d5461a138a"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "171a08e41e783343ce19cf7bb6ef89fea91ea902c42df32a123d38f1b23b70c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff89db81fedae1afb33ca081fff5842fff9c48bc1b9065c7a0c79a3523b5ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c5151d3e11a21ddb14d5f7f8729cb54e351a2e58641a4077af226401e38d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "74c29e7f1bd8bfefa8f70a127bdd307b40d0f60c271fd3135893f32c58a3b876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4af4d64c69968156ced07fe21e7078891b64758a8a1429440e8a88ef281fb5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2edcc38d0b3890b1322eff17eb7171657f58f7ab56ff5a6a2fd9f575949455"
  end

  # Unpin go when nuclei supports Go 1.26, in release including: https://github.com/projectdiscovery/nuclei/pull/6841
  depends_on "go@1.25" => :build

  def install
    odie "Unpin go@1.25 to use go 1.26" if build.stable? && version > "3.7.0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
