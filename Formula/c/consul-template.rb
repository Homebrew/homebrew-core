class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "def64b66c47dd38d98e37bfa1b571584ed9ab5f98be0dce09304c68b7ac966eb"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02da24d920a13464b0142d8ef17df9d4e75e112afc50a611500b130e6b8bb164"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02da24d920a13464b0142d8ef17df9d4e75e112afc50a611500b130e6b8bb164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02da24d920a13464b0142d8ef17df9d4e75e112afc50a611500b130e6b8bb164"
    sha256 cellar: :any_skip_relocation, sonoma:        "e038887669083dc2a0f7268c84d20d016ba640215a22b6f6fd5f8aaff82f6701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb718561d35e494246dcf5543235b4a8aa9900d54309854b9237b66f7c905dfd"
    sha256 cellar: :any,                 x86_64_linux:  "87e62e697cb123d62e2d81b28eb20e9bf28bd691d069660c2408567bace3a79a"
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
