class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.37.2",
      revision: "062dd605cfcd2ed5616c2f6b5aa35129554daa98"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a009e1dfeef2d1bc6d82e4d6bc2ff69facfc0d874f18544a789d3a9cc052547"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79a59a3b007713735298c4e16ae5ca785264c74214da0e154bce30c076655dea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "043edb4a5af95b87fae2ac750c44ac512f8c361fa8f33c71b1bd25259ffc3f54"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eed840ffb51f7254e2f994c25ef50056788795ae1460d646de42d3e81fe8aff"
    sha256 cellar: :any_skip_relocation, ventura:        "0c80fe2c38ce3fbef24e7405d62559886946fb6fd9a50e34785a5e5d7ddf8c51"
    sha256 cellar: :any_skip_relocation, monterey:       "56fbd56d74b0d3b1f790accc3486bff06ac6d613d4881c8329b269ee19b7b322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a4483bdccef069eefcf2405f965ee566b87c75e911fea9abf9ba8a1a187e9a"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
