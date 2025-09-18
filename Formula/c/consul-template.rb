class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "a5efe210996d56c375740d1efe4aed3e7e43ecaa517d38acc7c730f6cd4e1f60"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b2555d111bbf8059da9c912eab6b71986b123729c652b897ef0c36b007496af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7507f041a8c8f9317f1be6fd59b7205b16d7f07bc0eabdb74e43b2e821d94c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7507f041a8c8f9317f1be6fd59b7205b16d7f07bc0eabdb74e43b2e821d94c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7507f041a8c8f9317f1be6fd59b7205b16d7f07bc0eabdb74e43b2e821d94c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b77aadd8569fb1c591cc7127739a45bfd4c23531929c2da36f9b1e17d97ebb5"
    sha256 cellar: :any_skip_relocation, ventura:       "0b77aadd8569fb1c591cc7127739a45bfd4c23531929c2da36f9b1e17d97ebb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f0868d757719d1955d3e6dd554d267a1ed70a207a1d8dc92de18bb2566c36c"
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
