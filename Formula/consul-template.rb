class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.27.1",
      revision: "799d6561e1cfdc34c08352d23ebe623f40fb022f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1daf66b8cde3eb1483b130185eccaadd947686a830562d415dc92017f746b04a"
    sha256 cellar: :any_skip_relocation, big_sur:       "72d06c3eca6b73058c6fc7b35e9c275ab9a9fff8ecd0b1200520f1b711f25c74"
    sha256 cellar: :any_skip_relocation, catalina:      "5cb5d29ad3beb7cb51e9762f1908924a7a0e8cc8b3ae6bc10d9289818721c090"
    sha256 cellar: :any_skip_relocation, mojave:        "54d27658a88b49a16dd37995b435a6eb51d55d109e10aa584e39d91142784151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0834b775b96acd416a5177f9580fbfd54ff82dff79644ade93e9bde8edc608e"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
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
