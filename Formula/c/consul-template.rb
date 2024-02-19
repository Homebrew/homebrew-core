class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.36.0",
      revision: "8fdab02d459ae5a35982ff0689a4aadf82da7715"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e711298883b006a9fa0432631d7c637671c938fbc668db1f75b4e19e3fbd24a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85ded0afb95114ef771dcfab513aa38b66ea710f0c30812efbf69f2a2e45d155"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e50d8617a54f94cfec169ed7b1a8674d5ca19b872d6467f188a5b8cccc5de88d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5952509e49400f9fbc69244dcd462ea17e813a4bb870ab6a6401048b391860df"
    sha256 cellar: :any_skip_relocation, ventura:        "0ef923f774ea754c082bf65d06822d42bdb9d6814bb26aec85cdfa3c2601d114"
    sha256 cellar: :any_skip_relocation, monterey:       "64bd058340cc42c0745dd01d332cb95729906d2b4a1d54ed445e929ef9513ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae735dec296d75b2276bf6589ac0cb65881c49e8641122789f6446e0b7bc3e1a"
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
