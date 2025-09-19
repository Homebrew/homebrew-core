class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.41.2.tar.gz"
  sha256 "9a89232a6d7c1ff835cf2ff78ce03ce5cde5b45a6e45c01297ce8e22b2fba544"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2fdd58c6f09812fabfc679fa175197e2e7c65bc25dd269607003d2e0f335259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2fdd58c6f09812fabfc679fa175197e2e7c65bc25dd269607003d2e0f335259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2fdd58c6f09812fabfc679fa175197e2e7c65bc25dd269607003d2e0f335259"
    sha256 cellar: :any_skip_relocation, sonoma:        "d759503f5c78aed481472b733b86c859aa95c84cf2d154a3c6bb64fcb53adf51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb6abd303067ca184a7543c872504943abc642003654f63f6a8a73a640b5030"
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
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
