class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.34.0",
      revision: "58a31b44ecca1ece68ca7bbfc0ad6ca9e8f8ad6b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4b98f3e748f9767126eaaab1e1f12cd2a312ab3cedbf72888a42f97dab9992e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8a456280eaa85b50b690f6d30f0887130c1b73a3d011b3a007b783124775122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68eae6b71a6f88a62b639e5d624cf9efaa93f465f0b885859d954c32906ed76e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3829eccc6cf3170f543bd7b364c9cdf4196a253966aa548546fe00869d785984"
    sha256 cellar: :any_skip_relocation, ventura:        "16267951bb4d6c64959298c7a7f93e73cd0beeec562197bc8c3916092da4b5bf"
    sha256 cellar: :any_skip_relocation, monterey:       "30d4883bd1eb0cb23bce97033cd1998367823bf6da338456e022c9d90e2e157b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ed971e608888a95bf073243339c98f204f318a6d0cedc9e8bff0f7b6f52d5b"
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
