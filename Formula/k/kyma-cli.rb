class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/2.20.1.tar.gz"
  sha256 "f9ed216465b3b3124efb299c9a0f444a6294eed65243a08d5c0765048a05d0f0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "164e3106f527508298d3f8b9e1e61593752bb8c53d0d4eb513b0db8069e08333"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf76df40c3ec1a891527d73fcff5368c31fce2dfabdf8d3056e3d305448d6af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f5caaffad48fd69848b2c5479f42bcf10e314412f767e6ab6ae4e5a13b5dad0"
    sha256 cellar: :any_skip_relocation, sonoma:         "27205f4d2c9eaf90c5c4c5cb6403629b9b3c6625c43da064e6a970d79ed4327d"
    sha256 cellar: :any_skip_relocation, ventura:        "763aa28e48a43c22bf03dfa6bc216ffd7f955bee58f166bf1c2a51517e98fc5f"
    sha256 cellar: :any_skip_relocation, monterey:       "93d1c66643aa781e70244c89fc72116fd7a9b24ca6f239877d8e313ba7af5e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fc307b6fedf51d116f99d9d060efafc77258ec12903ec9a00ab5e28fcb5a09"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end
