class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.32.0",
      revision: "a9261315d223a0746bfe391ccc6530bf4050e3bf"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82b8013d18fa946fcdf9cea17900f6123ee6e4017acea78e71210e78f3df23a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82b8013d18fa946fcdf9cea17900f6123ee6e4017acea78e71210e78f3df23a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82b8013d18fa946fcdf9cea17900f6123ee6e4017acea78e71210e78f3df23a8"
    sha256 cellar: :any_skip_relocation, ventura:        "e05e3cec03a329a2b5dcca4dee3416c171fe58689673e51d7b18ca144ed88ea7"
    sha256 cellar: :any_skip_relocation, monterey:       "e05e3cec03a329a2b5dcca4dee3416c171fe58689673e51d7b18ca144ed88ea7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e05e3cec03a329a2b5dcca4dee3416c171fe58689673e51d7b18ca144ed88ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66455db2c137791a9b6fbaed600a6096c48a9eca07da67d441131404910a085"
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
