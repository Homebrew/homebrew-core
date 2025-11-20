class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "a80159ccc6ed0f9a014d3d18b5cae3fb5421b4992c731ed54002380f411e2db9"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4076b20e97ddce3bd32933c557dadb92104776fbda8b548f5c2a7a7d9b3c47b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea8208d34ab4de3ddcb58cfd1017c364c78ee3214cb2967cbb844a3b7c0c6a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2744cfef1a0206172c7bad54400c4db68351b2161139df98e7d852f416f0664e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbb50d744ce5d94acd6946e3aeaa2ee34c3a540f0489d9208ffffb3f01efb172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "161b5f0ff5b2cbcd6487217ec102c790393a1d68e57a14f942d19078315f3d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e500219ba9c699950c039fb1c71ef4ce4bebc8c8522309e86585f665bc8118"
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
