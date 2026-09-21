class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "95b2f441437ceafb8dadea03aa62589d78fd03d0dc31005cf51d4042c3d6fe74"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e564daf656a0e04d0d13d54e936b0875a6b897628e31fad80be8ba0bcc75c5dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e564daf656a0e04d0d13d54e936b0875a6b897628e31fad80be8ba0bcc75c5dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e564daf656a0e04d0d13d54e936b0875a6b897628e31fad80be8ba0bcc75c5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e564daf656a0e04d0d13d54e936b0875a6b897628e31fad80be8ba0bcc75c5dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64fe32e5524311f94fa66b75abe95fb324b31891f561c1f898a1efd8b88504e5"
    sha256 cellar: :any,                 x86_64_linux:      "23bb9614d7b94383117f4b699fe7e13a9df101c9383213c2f624aa520ce66d7e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
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
