class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.3.10.tar.gz"
  sha256 "ff6051120f436ca2ed5ef3e645f9217492cbf42c92748aeabc57b9808ff0d14f"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d065608dfff9c82b38186f5a5a42347139c4f7370b26e6c4008532676ce236d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f558547cc7fc5b395330a840f26a15d47267771bc4827ca7cdfcb147ec6f8974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a12c05aad597afd3bce3fa13e7b2fd1c0608b1877c2826caea4469dc0c7db30"
    sha256 cellar: :any_skip_relocation, sonoma:        "8217becb61b0950c4d71f2e1c2f9e7f3e5f206d9a888104dff6e7978e1b1fde1"
    sha256 cellar: :any_skip_relocation, ventura:       "6678e44fe90aebf68c5cbda9c24281e03e411a4c1ff0d0443767a9c8902404d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26399aa4263338e66df18bb0f9874382d5949906d9ecfef4a4445ab432309982"
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
