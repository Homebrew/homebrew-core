class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "72114ba643e3064ae96d143bb487e2feeaa17b5485396f3ca3d59de1547e022c"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9ca35d61df37b073189b5747872b15b5fdeb5dd13b1a5e690f283daf57b3ef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4601daddf021c866928ef6f223a9d678b5b7bde04602b8115fa8033ccb5e3222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52ba87ec1cd9f028df92c8f4c2bc9404bb28710a8809c6eff6d8812bb4d23aa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d610038bd7ed6b58f8e427fa77a1cd27cd4ba639773196ad930c944a8f6f93bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1ffccc851b3795f755d0623d42db09370f18def0a58bb87f3cca00076cfd39e"
    sha256 cellar: :any,                 x86_64_linux:  "07e1e02d61de9917f1d257e6916adce037411eeecfa80fe5f62b29bb80b5831c"
  end

  depends_on "go" => :build

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
