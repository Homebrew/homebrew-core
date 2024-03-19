class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.37.2",
      revision: "062dd605cfcd2ed5616c2f6b5aa35129554daa98"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "721b4b42718a32900e92ff94bd02445b8a7d4ba9713adaa50f7b200f462308ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7950d7e8d0c0ceb889465ca5a077ae4e0ff2e3ccb5dc6d4779cede5491e0991"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616690e1b0584b52f54086d11004d660c67109668722bf06a392a1b122284094"
    sha256 cellar: :any_skip_relocation, sonoma:         "0200d5edb4c87d86517703a4fea83e0299f4f862f52515a2166bcaa5a8a2f0d6"
    sha256 cellar: :any_skip_relocation, ventura:        "f41613200c3c8365ae42ba556b643d01c260482f8b7f6ec6b580d78f9e8375b3"
    sha256 cellar: :any_skip_relocation, monterey:       "da24c88ecb985eb2dba73c1f2ed3408a7eb9bf34c2b75dd9654083232b0e9ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e5fef2174945168f5fca4b4b0e6044aa99bfd75634f500789edfb84d1db058"
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
