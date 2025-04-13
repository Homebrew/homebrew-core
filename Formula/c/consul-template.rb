class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "cb74e87b972f6450f33c267cca332737aca00fa51d25c3fae65048158d393b27"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368a75569525e7512f65e51d89af81a299732099f24aff6d4af0c473caadf8ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368a75569525e7512f65e51d89af81a299732099f24aff6d4af0c473caadf8ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "368a75569525e7512f65e51d89af81a299732099f24aff6d4af0c473caadf8ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "335573d7ba780228b60e9e93f01e37600c3fb62988328be963a7e24c6ce137a1"
    sha256 cellar: :any_skip_relocation, ventura:       "335573d7ba780228b60e9e93f01e37600c3fb62988328be963a7e24c6ce137a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca6f0ad7417f567f58295292468355109990ab7d0ffb715b09deb7b599f6ea0"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
