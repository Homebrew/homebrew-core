class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "19add3cd361217cd2406e70e910116305fa83d6c6d1d173f0c8b72136a98dadd"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f24a9ced1af4e506e6e36fbce237a3ed68de57690c2705267430c33a762733"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb957c5ac6af3b43b7861d0d77327da7f6bee9fc73db6ff5cc1ad4f5dd170554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8b7aa9831459e6f827d54d999b4dbe4d5da83b3655b532b48f76e2b9453d2ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e2aad7ba120f65dde7cb87e6ff9b48833504a5a5adff2ea948fa214adf73e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d751097ba5f2bcb36a7d297f6db6130f44873e666363a6195e38bcce984be360"
    sha256 cellar: :any,                 x86_64_linux:  "ad8c6c5656d53bbe64b992cc25a24dd389e6a0085128ecf54caf3642b3f2003a"
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
