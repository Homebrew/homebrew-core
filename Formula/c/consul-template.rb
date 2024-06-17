class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "9821906f975e960244649f6a7fa026fa006994ea8d79148e92c0691aad7ead12"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00aac0564d14fc5501897f188dfff187c7debe83b321d85731fb0a338d16873c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d319206f67e9433ab92f69b735242c328c40cab6351dc960eeadef2410882e9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4ea4e99594f1502992ba27d9bdcc6f2b4496909bff2a31e281baca69efe44b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "76222b88a9b646383d8315e9604bcfa919a5454dcddc3cfa9e7ca3026e161486"
    sha256 cellar: :any_skip_relocation, ventura:        "5409f2b065224f808bd4a53fe3455be33053ade0b4fe529f2a214fa64ade6678"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7b3a18f6faff7cfc46baabd048e5eea297ed123886b041b64c827a34c40c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9862dddf20abc1165b377f064f60f11f5386edd79660703bf405bb95381e4a"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{tap.user}
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
