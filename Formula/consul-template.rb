class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.29.5",
      revision: "f07ce88535e6314e09784e021a29697f97d9edad"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fed41eebd6d023e294c27c465112584b74f86c6f00c43a062ee520e2eaf2e13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "154b158aef59b9debe68193e0e5b83750a1c7a69f87a9db1b11a97518f272eaa"
    sha256 cellar: :any_skip_relocation, monterey:       "146ee8a52d7275e6f1f18988b7c2f53da62d418b3c18e3d27a8f579abfa74978"
    sha256 cellar: :any_skip_relocation, big_sur:        "e042c1ea4ab1539f5303701954df7e817e0f45366dd62000e2181240b1652e6f"
    sha256 cellar: :any_skip_relocation, catalina:       "cf2f7c9b520e45b44b093bb01b650eb6e18dc470d396aa8dfa3baa5231837b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553725d4321bf445c741bfa3d02557b2b21bb1d2b3c90c4daf16105b3f166c09"
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
