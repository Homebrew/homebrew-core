class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.33.0",
      revision: "15b89c9ba3a6712c95b484de81638ec0392e2eb7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03eb51783a49413b4d19a745c0a26dfe5607c62dc7df8664f6bf4fc901148ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03eb51783a49413b4d19a745c0a26dfe5607c62dc7df8664f6bf4fc901148ea5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03eb51783a49413b4d19a745c0a26dfe5607c62dc7df8664f6bf4fc901148ea5"
    sha256 cellar: :any_skip_relocation, ventura:        "aaaa55f835282cac99d2b398eea04532c91919b635965f00b54eb55fbeb013c1"
    sha256 cellar: :any_skip_relocation, monterey:       "aaaa55f835282cac99d2b398eea04532c91919b635965f00b54eb55fbeb013c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaaa55f835282cac99d2b398eea04532c91919b635965f00b54eb55fbeb013c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f4bf810b74415d087d1cda7cdc9c0f955cc07c7273ceb076743152e4dc7d97"
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
