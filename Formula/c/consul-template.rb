class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "97c588a368c49e0478a65337a65b97031affb8a718446a4486759c1d3da6202d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "659d54df60521806c2406c3952526a5572dc5e90afd78e8f09f38e2966dffcea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "659d54df60521806c2406c3952526a5572dc5e90afd78e8f09f38e2966dffcea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "659d54df60521806c2406c3952526a5572dc5e90afd78e8f09f38e2966dffcea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "41541071e076a83c1b671b9310352439622002e4310feafd0ad7c647f0ed927d"
    sha256 cellar: :any,                 x86_64_linux:      "97110ad07aec01c9c974dfb6cc03edfb2179a91513e5ca9936d08106894a5cb6"
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
