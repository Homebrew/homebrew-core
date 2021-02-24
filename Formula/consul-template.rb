class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.25.2",
      revision: "870905de57f085588c3b718b779d8550aefc5dcf"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "544c3c24e47bc1bca4d2596e47e648f03ff4817386d9c23b5ebe70c145efa982"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4a3b5b3ca203f027b52a4b42be5b5cce56bfa9f062ba4742dabd4863e3d3fb8"
    sha256 cellar: :any_skip_relocation, catalina:      "53ecc8ea5c9da1cab8105850feeb3d07dc3a2f82d656a113c3fdf47f4d296c61"
    sha256 cellar: :any_skip_relocation, mojave:        "8d40ff085b204ad666540946e7104c1e9d7e371a8e92aacb2569c8377a649edf"
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
