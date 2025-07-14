class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "8cf922fa04fd26b035e00ffbb300101e11aeb54edbfc0364f7dd4270370f18cf"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0155355643cf7b119fe853f46489d4e45c31b546e999450077733285d7e9497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0155355643cf7b119fe853f46489d4e45c31b546e999450077733285d7e9497"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0155355643cf7b119fe853f46489d4e45c31b546e999450077733285d7e9497"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e86525b036074d8ec4dac6e073c53a41ec4b4c098d1e1c539bb413bed9182d"
    sha256 cellar: :any_skip_relocation, ventura:       "c1e86525b036074d8ec4dac6e073c53a41ec4b4c098d1e1c539bb413bed9182d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e759cac1a4cd4b8d8981adc9cb4174c5bafaeecd9b90c9be0b48a86ea2c95d6"
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
