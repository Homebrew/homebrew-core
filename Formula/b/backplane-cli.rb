class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "8c97efdbc41f99cb280c2549f1502a26b8b8183c1a7e4d93ae85b4f9e2e0a83f"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dafaf178b34e0393bef1b0101b7f9acf4bd0187d6e2a4a874b38a9c04894f27b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4ced5e58129de6064ddfda53b25e8f072f0d652848acab55dd824ee7f52d505"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "626c1533dda34c3fc15e9d49c94c76520f222335b1bcac809f17261a4fc05557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2a0759915b56fd9dca487999ec65ea018b662b97d4987d33225e6f28a8e08f1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98c25bff5f5fa447f14afe58bc0dabaf3a892d20bd1f622e6c408347acc5694d"
    sha256 cellar: :any,                 x86_64_linux:      "45b4a83837e9300ead60a8c61c5de9c2a289cf7ef5476e15b5998abf01bea591"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/openshift/backplane-cli/pkg/info.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocm-backplane"), "./cmd/ocm-backplane"
    generate_completions_from_executable(bin/"ocm-backplane", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm-backplane version")

    # Verify config set persists to disk
    ENV["BACKPLANE_CONFIG"] = testpath/"config.json"
    system bin/"ocm-backplane", "config", "set", "url", "https://test.example.com"
    config_json = JSON.parse(File.read(testpath/"config.json"))
    assert_equal "https://test.example.com", config_json["url"]
  end
end
