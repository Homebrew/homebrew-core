class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.27.2",
      revision: "0400fa21081d44bd8aeccf858f093c2fe13d7774"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69ed2c46cd1e25f25ab11616c006d93d30da6e9c4e7da7a7c3dce0d68f834c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b474a4a2916237ec59dc707f36c489a4eec3357ecbf3be9d8c9082309ba70c3"
    sha256 cellar: :any_skip_relocation, monterey:       "824b80e4a9bf23cdf55eb2dcbe19152f503b63ecdf87e3046a2d81c46fd93053"
    sha256 cellar: :any_skip_relocation, big_sur:        "7df1b1a0c6e6143a37a79bc99e240e84bec86fd32778fea9af7c46e8db1dba46"
    sha256 cellar: :any_skip_relocation, catalina:       "08678956dec8f5c99e090fc677eea605241d6a0e71fb6d699e664b3d7d77952f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d38fc173ac90f35cfd01479ce75b241ff8f2abc91841b959820ba748de1fadd"
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
