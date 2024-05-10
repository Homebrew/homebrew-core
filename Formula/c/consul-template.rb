class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.37.6.tar.gz"
  sha256 "25c295198427fd3480b9333128e8d8b495d2e85b3c2749ce611da8e248208d82"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "527a98a579f4cb66bd0c4f7cb32acd9c6e362712b59810343d159374b82837b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "118ea52520e40285eaf67deb88a8eed1111777d14c86ef0e8829b097affecfb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46b2722c4b18bd642fe0dca8139d4fc5f2974ffa896272f09b43d59b836c3711"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd10dc79205fdb9ab304e9dd3bf98153beaa3ca7e12e9f25d090ccf04c20fa27"
    sha256 cellar: :any_skip_relocation, ventura:        "f3b12247828f3023146bca3f9a7c13945aa6cab3dff9467d242566176a24768a"
    sha256 cellar: :any_skip_relocation, monterey:       "cdef8a66096ffa0016013597126d830abe239396ace0e637da3e586cbc62c03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8154fff01f24d37329d45daf60e5039761bd794e2d8a05c9b5c44b0e377e6d"
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
