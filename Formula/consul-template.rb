class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.28.0",
      revision: "ae2bbca18a8cf6c549b73a60dd26a86c814b95ed"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fcbca74682be77f3d3a7c148dfcf98da2369f1f26281c914d9c775e827eeacb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5abae2cd7ff00a6e717e1c03b13d756b688c84a2e5aebd874d558e0808f63135"
    sha256 cellar: :any_skip_relocation, monterey:       "78f300b6baa5ac00a4bfe5f9cbfe056a44b70bc56ca625a50faf206a3ed69138"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ce95bdbde710d0e9c855cc89d6728c2237c590ba23060aae2c9f9e34a6b53a5"
    sha256 cellar: :any_skip_relocation, catalina:       "54f51f6fa6fb4edebf3f5874156a4dd446760105eaa0a0c31b9dd4e41a3fc406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a67f3a655d2df8bf65997dd4bb2ecdbe05496a4394361e6c67e33d76091020"
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
