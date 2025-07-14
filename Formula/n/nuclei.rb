class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.4.7.tar.gz"
  sha256 "71d7cf669dd4641538e7526d694d33eb5b3fae36688188d4c2b01c8103e4ef6e"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54f15f4828dd677817232d16d256f9870c3ced97a687fd428c9f4ac13186ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd4fb40b5e78afb64c3ed5a1e2d2aa051c7cd1bb4f8443ec876d1a739b01e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c5eea86f61a1061a21aa694638794c5bdaee175b87c6364905b73dd5b077237"
    sha256 cellar: :any_skip_relocation, sonoma:        "406155b6d89564daffad2f58ec400b9239e394d176830ccf4fb7769574a5a31d"
    sha256 cellar: :any_skip_relocation, ventura:       "49a2582eeef75f00874d6c087b99216c8d4a5b815ae38286b92f1926fc64062f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20760e217dc19818eb98dd5a6e65ff883cf52fae2a73e4eb1a77610ac0660d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6194ec99323447656ed85edc049f7d3017be80c2a09e16b0b62fab34b66341e9"
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
