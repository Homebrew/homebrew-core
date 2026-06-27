class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "4aedfb41d74a95d4b8648182ae1df9ad3d6f44767e0c14614ce251e59a9fba8a"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72e479203ae842346c1f785e310a1478f8979fb079947baf16e1b47539c88927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfc1fb648a628e8d12fb29fbada2f663a0680400935acc7b316585dba340c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "320854b0ded420535a682378630c8e4c00146c2be7ce23e73fc7839e3cdaeced"
    sha256 cellar: :any_skip_relocation, sonoma:        "13fec9ce9b3a12b97f3d52d41a0adbac82d2c9fa965b258ef89cfb15f3dc57e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df069701967fbcc97373fa59071de16a5c9eb78c0e7ad5d91451ddf07bbe7dca"
    sha256 cellar: :any,                 x86_64_linux:  "4d1b6c16641b31b15024e8165968c32dd4269dda36c7de7561231f6bdbad5a5f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openshift/backplane-cli/pkg/info.Version=#{version}
    ]
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
