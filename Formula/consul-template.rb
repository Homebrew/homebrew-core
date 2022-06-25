class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.29.1",
      revision: "4525703f9dd1347a38446e137d56de94dcd06ee7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91eff4b8d9aeda6a30b5b5d00c12bbb7404222630b61dfb99d660ebd8dc8cffc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1093b3c02a63c7996a6d0c2b906b4f0bc3c9fb8f64a3a6383cde68d7a6a26ef6"
    sha256 cellar: :any_skip_relocation, monterey:       "836a0f9610fb66d478aab42e635a1742b06a905d448faa4b9963a4f3bec05e2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a78576ca8aac42a9c5ace65c4dab8c0ca5cd7088c4062e5697f41b5645f3fc0d"
    sha256 cellar: :any_skip_relocation, catalina:       "c24429569d2c1234454b82d6eb88f98d91611edef8f400295c181866323a3834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4197c506f6897da3a118cf5c0e17ffce0cc228de057dfdb893e3f513c87fae32"
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
