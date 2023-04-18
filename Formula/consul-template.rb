class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.31.0",
      revision: "6bf92e84926adf1366d0a16395930ddc5c82bca5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab4b8bb03334e33826d83fbfc2eafd1a966285139c256ab3056e505ecce3e698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab4b8bb03334e33826d83fbfc2eafd1a966285139c256ab3056e505ecce3e698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab4b8bb03334e33826d83fbfc2eafd1a966285139c256ab3056e505ecce3e698"
    sha256 cellar: :any_skip_relocation, ventura:        "0979448a31d15585669d4d2e5da6e2e441ec11dac23860a7adffbdd8583ffe61"
    sha256 cellar: :any_skip_relocation, monterey:       "0979448a31d15585669d4d2e5da6e2e441ec11dac23860a7adffbdd8583ffe61"
    sha256 cellar: :any_skip_relocation, big_sur:        "0979448a31d15585669d4d2e5da6e2e441ec11dac23860a7adffbdd8583ffe61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8595688c63f8e5813d7d80c679b4a93dcb211c695896a4141cffafa84ab437c7"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    prefix.install_metafiles
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
